# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  authenticates_with_sorcery!

  FIELDS_FOR_COMPLETE = [
    :name, :city, :born_at, :gender,
    :company, :position, :website
  ]

  validates :email,
    format: /.+\@.+\..+/,
    uniqueness: true,
    if: :email

  validates :merge_email, format: /.+\@.+\..+/, if: proc { merge_email.present? }

  validates :password, length: { minimum: 6 }, if: :password
  validates :password, confirmation: true

  before_validation :process_new_city
  before_validation :ensure_uniqueness_name

  before_destroy :user_deleted
  after_save :check_complete

  before_validation :delete_all_other_pending, if: proc { activation_state == 'pending' }
  before_validation :select_state

  attr_accessor :new_city, :new_country_cd
  attr_accessor :password_confirmation

  attr_accessible :born_at, :gender_cd, :city_id, :new_city,
                  :new_country_cd, :company, :position, :website,
                  :phone_number, :name, :gender, :email, :avatar,
                  :comment_notification, :event_notification,
                  :partner_notification, :weekly_notification, :state,
                  :active_subscription, :password, :password_confirmation,
                  :article_comment_notification

  attr_accessible :state

  has_many :authentications, dependent: :destroy
  has_many :comments, foreign_key: :author_id
  has_many :subscriptions, dependent: :destroy
  belongs_to :city

  accepts_nested_attributes_for :city

  mount_uploader :avatar, UserAvatarUploader

  as_enum :gender, male: 1, female: 2

  scope :activated, where(activation_state: 'active')
  scope :with_subscription, where(active_subscription: true)

  state_machine :state, initial: :need_info do
    after_transition any => :banned, :do => :banned_user

    event :complete do
      transition all => :complete
    end

    event :banned do
      transition all => :banned
    end

    event :need_info do
      transition all => :need_info
    end
  end

  scope :activated, where(activation_state: ['active', nil])
  scope :pending, where(activation_state: 'pending')

  def banned_user
    UserMailer.user_banned(self).deliver
  end

  def activate!
    ensure_plain_password
    super
  end

  def ensure_plain_password
    if password.blank?
      self.password = SecureRandom.hex(4)
    end
  end

  # this method generates merge token and sends emails with link
  def setup_record_merge!(email)
    self.merge_token = SecureRandom.hex(10)
    self.merge_email = email
    self.merge_token_expires_at = DateTime.now + 2.days
    self.save!
    UserActivationMailer.merge_need_email(self).deliver
  end

  def self.load_from_merge_token(token)
    User.where(merge_token: token)
        .where('? <= merge_token_expires_at', DateTime.now).first
  end

  def merge_with_other!
    self.email = merge_email
    other_users = User.activated.where(email: merge_email)
    other_users.each do |user|

      user.subscriptions.each do |sub|
        sub.user_id = self.id
        sub.save!
      end
      self.subscriptions(true)

      user.comments.each do |comment|
        comment.author_id = self.id
        comment.save!
      end
      self.comments(true)
      
      user.authentications.each do |auth|
        auth.user_id = self.id
        auth.save!
      end
      self.authentications(true)

      self.city           ||= user.city
      self.born_at        ||= user.born_at
      self.gender         ||= user.gender
      self.company        ||= user.company
      self.position       ||= user.position
      self.website        ||= user.website
      self.phone_number   ||= user.phone_number
      self.name           ||= user.name

      self.article_comment_notification = user.article_comment_notification
      self.comment_notification         = user.comment_notification
      self.event_notification           = user.event_notification
      self.partner_notification         = user.partner_notification
      self.weekly_notification          = user.weekly_notification

      self.active_subscription |= user.active_subscription

      # TODO load other user avatar if present
      
      user.delete
    end
    self.save!
  end

  def free_name?(name)
    query = name.gsub('%', '\%').gsub('_', '\_')
    not User.where("id <> ?", id).where("name LIKE ?", query).any?
  end

  def active_subscription?
    active_subscription
  end

  def pending_subscription
    return nil if active_subscription?

    subscriptions.where(state: 'pending').newer.first
  end

  def social_auth
    authentications.first
  end

  def social_url
    return unless auth = authentications.first
    case auth.provider
    when 'vk'
      "https://vk.com/id#{auth.uid}"
    when 'facebook'
      "http://www.facebook.com/#{auth.uid}"
    end
  end

  private

  def delete_all_other_pending
    if new_record?
      ::User.pending.where(email: email).delete_all
    else
      ::User.pending.where('id <> ?', id).where(email: email).delete_all
    end
  end

  def select_state
    complete = true
    FIELDS_FOR_COMPLETE.each do |sym|
      if send(sym).blank?
        complete = false
        break
      end
    end
  end

  # use separate validator instead of uniqueness: true
  # that need to compare names case-insensitive
  def ensure_uniqueness_name
    self.name = nil if name and not free_name?(name)
  end

  def process_new_city
    name = new_city.to_s.strip
    return if name.blank?
    country_cd = new_country_cd
    city = City.new
    city.name = name
    city.country_cd = country_cd.to_i
    city.save!

    self.city_id = city.id
  end

  def user_deleted
    UserMailer.user_deleted(self).deliver
  end

  def check_complete
    return self.complete?
    FIELDS_FOR_COMPLETE.each do |f|
      return if self.send(f).nil?
    end
    self.update_column(:state, 'complete')
  end

end

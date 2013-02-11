class User < ActiveRecord::Base
  authenticates_with_sorcery!

  FIELDS_FOR_COMPLETE = [
    :name, :city, :born_at, :gender,
    :company, :position, :website
  ]

  # removed presence: true for a while.
  # TODO: figure out how to deal with oauth-users without email
  validates :email,
    presence: true, format: /.+\@.+\..+/,
    unless: proc { state.to_sym == :need_email }

  validates :merge_email, format: /.+\@.+\..+/, if: proc { merge_email.present? }

  # email should be unique or be nil
  validates :email, uniqueness: { scope: :state }, unless: proc { email.blank? }
  
  validates :password, length: { minimum: 6 }, if: :password

  before_validation :process_new_city
  before_validation :ensure_uniqueness_name
  before_validation :select_state
  before_validation :delete_all_other_pending, if: proc { activation_state == 'pending' }

  attr_accessor :new_city, :new_country_cd

  attr_accessible :born_at, :gender_cd, :city_id, :new_city,
    :new_country_cd, :company, :position, :website,
    :phone_number, :name, :gender, :email

  attr_accessible :article_comment_notification, :comment_notification,
    :event_notification, :partner_notification, :weekly_notification

  has_many :authentications, dependent: :destroy
  has_many :comments, foreign_key: :author_id
  has_many :subscriptions, dependent: :destroy
  belongs_to :city

  accepts_nested_attributes_for :city

  mount_uploader :avatar, UserAvatarUploader

  as_enum :gender, male: 1, female: 2

  scope :activated, where(activation_state: ['active', nil])
  scope :pending, where(activation_state: 'pending')

  state_machine initial: 'need_info' do
    state 'need_email'
    state 'need_info'
    state 'complete'
    state 'disabled'
  end

  def activate!
    if password.blank?
      self.password = SecureRandom.hex(4)
    end
    super
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
    other_users = User.where('activation_state <> ?', 'pending')
                .where(email: merge_email)

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

    if email.blank?
      self.state = 'need_email'
    elsif complete
      self.state = 'complete'
    else
      self.state = 'need_info'
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
end

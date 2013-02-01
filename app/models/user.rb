class User < ActiveRecord::Base
  authenticates_with_sorcery!

  FIELDS_FOR_COMPLETE = [
    :name, :city, :born_at, :gender,
    :company, :position, :website
  ]

  # removed presence: true for a while.
  # TODO: figure out how to deal with oauth-users without email
  validates :email, presence: true, format: /.+\@.+\..+/, unless: "state == :need_email"
  validates :email, uniqueness: { scope: :state }, unless: "email.empty?"

  validates :password, presence: true, if: "crypted_password.blank?"
  validates :password, length: { minimum: 6 }, if: :password

  before_validation :ensure_password
  before_validation :process_new_city
  before_validation :ensure_uniqueness_name
  before_validation :select_state
  before_destroy :user_deleted
  after_save :banned_notify, if: "banned_changed?"

  attr_accessor :new_city, :new_country_cd

  attr_accessible :born_at, :gender_cd, :city_id, :new_city,
                  :new_country_cd, :company, :position, :website,
                  :phone_number, :name, :gender, :email, :avatar,
                  :comment_notification, :event_notification,
                  :partner_notification, :weekly_notification, :state,
                  :active_subscription, :password, :password_confirmation,
                  :article_comment_notification, :as => [:default, :admin]

  attr_accessible :state, :banned, :as => [:admin]

  has_many :authentications, dependent: :destroy
  has_many :comments, foreign_key: :author_id
  has_many :subscriptions
  belongs_to :city

  accepts_nested_attributes_for :city

  mount_uploader :avatar, UserAvatarUploader

  as_enum :gender, male: 1, female: 2

  scope :activated, where(activation_state: 'active')

  state_machine initial: 'need_info' do
    state 'need_email'
    state 'need_info'
    state 'complete'
    state 'disabled'
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
    when 'vkontakte'
      "https://vk.com/id#{auth.uid}"
    when 'facebook'
      "http://www.facebook.com/#{auth.uid}"
    end
  end

  private

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

  def ensure_password
    if crypted_password.blank? and password.blank?
      self.password = SecureRandom.hex(4)
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

  def banned_notify
    if banned
      UserMailer.user_banned(self).deliver
    else
      UserMailer.user_unbanned(self).deliver
    end
  end

  def user_deleted
    UserMailer.user_deleted(self).deliver
  end

end

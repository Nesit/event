class Subscription < ActiveRecord::Base
  as_enum :kind, six_months: 1, one_year: 2, two_years: 3

  attr_accessible :user_id, :kind, :print_versions_by_courier

  belongs_to :user

  validates :kind_cd, :user_id, :state, presence: true
  validates :activated_at, :ended_at, presence: true,
    if: lambda { state.in? [:active, :expired] }

  state_machine initial: :pending do
    state :pending
    state :active
    state :expired
  end

  scope :newer, order('subscriptions.created_at DESC')
  scope :older, order('subscriptions.created_at ASC')
  scope :pending, where(state: 'pending')
  scope :active, where(state: 'active')

  def amount
    normal_hash = {
      six_months: 600,
      one_year: 1000,
      two_years: 1800,
    }
    advanced_hash = {
      six_months: 1250,
      one_year: 2000,
      two_years: 3500,
    }
    (print_versions_by_courier ? advanced_hash : normal_hash)[kind]
  end

  def activate!
    self.activated_at = Date.today
    self.ended_at =
      case kind
      when :six_months
        Date.today + 6.months
      when :one_year
        Date.today + 1.year
      when :two_years
        Date.today + 2.years    
      end
    self.state = :active
    user.active_subscription = true
    user.save!
    save!
  end

  def check_expiration!
    return unless state == :active

    if ended_at < Date.today
      self.state = :expired
      user.active_subscription = false
      user.save!
      save!
    end
  end
end
class PartnerNewsletter < ActiveRecord::Base
  attr_accessible :title, :state, :started_at, :text

  validates :title, :text, presence: true

  scope :pendings, -> { where(state: :pending) }
  scope :need_to_send, -> { pendings.where('started_at BETWEEN ? AND ?',
                                          Time.zone.now - 10.minutes, Time.zone.now + 10.minutes)}

  state_machine :state, initial: :pending do
    event :in_progress do
      transition pending: :in_progress
    end

    event :done do
      transition in_progress: :done
    end

    event :reject do
      transition pending: :reject
    end

    event :activate do
      transition reject: :pending
    end
  end

  # Default values
  def started_at
    self[:started_at] or Time.zone.now + 5.hours
  end
end

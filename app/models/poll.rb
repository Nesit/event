class Poll < ActiveRecord::Base
  validates :topic, :start_at, :end_at, :published_at, presence: true

  attr_accessible :topic, :start_at, :end_at, :published_at, :choices_attributes

  has_many :votes, class_name: 'PollVote'
  has_many :choices, class_name: 'PollChoice'
  has_many :comments, as: :topic

  accepts_nested_attributes_for :choices

  before_validation :remove_empty_choices
  before_validation :ensure_published_date

  scope :newer_started, order('polls.start_at DESC')
  scope :newer, order('polls.created_at DESC')
  scope :older, order('polls.created_at ASC')

  # polls that are active right now
  scope :running,
    lambda { where('start_at < ?', DateTime.now)
               .where('? < end_at', DateTime.now) }

  # for social share partial
  def title
    topic
  end

  def running?
    now = DateTime.now
    (start_at < now) and (now < end_at)
  end

  def self.unvoted_poll_for(user)
    if user.nil? or user.new_record?
      running.newer_started.first
    else
      unvoted_poll = nil
      running.newer_started.each do |poll|
        unless poll.voted?(user)
          unvoted_poll = poll
          break
        end
      end
      unvoted_poll
    end
  end

  def record_pageview!
    self.pageviews_count += 1
    save!
  end

  def voted?(user)
    if user.nil? or user.new_record?
      false
    else
      votes.where(user_id: user.id).any?
    end
  end

  def next_poll
    self.class.where('polls.id <> ?', id)
              .where("polls.published_at < ?", published_at).first
  end

  def previous_poll
    self.class.where('polls.id <> ?', id)
              .where("polls.published_at > ?", published_at).first
  end

  private

  def remove_empty_choices
    to_remove = []
    choices.each do |choice|
      to_remove.push choice if choice.title.blank?
    end
    to_remove.each do |choice|
      choices.delete(choice)
    end
  end

  def ensure_published_date
    self.published_at ||= DateTime.now
  end
end

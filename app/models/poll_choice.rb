class PollChoice < ActiveRecord::Base
  validates :title, :poll_id, presence: true

  attr_accessible :title

  belongs_to :poll
  has_many :votes, class_name: 'PollVote', dependent: :destroy

  def voted?(user)
    if user.nil? or user.new_record?
      false
    else
      votes.where(user_id: user.id).any?
    end
  end

  def votes_percent
    if poll.votes.count == 0
      0
    else
      (votes.count * 100)/poll.votes.count
    end
  end
end

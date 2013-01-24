class PollVote < ActiveRecord::Base
  validates :poll_id, :poll_choice_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :poll_id }

  belongs_to :user
  belongs_to :poll
  belongs_to :poll_choice
end

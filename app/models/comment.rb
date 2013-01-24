class Comment < ActiveRecord::Base
  paginates_per 5

  validates :author_id, :body, :topic_id, :topic_type, presence: true
  attr_accessible :body, :topic_id, :topic_type, :topic, :ancestry

  belongs_to :topic, polymorphic: true
  belongs_to :author, class_name: 'User'

  scope :toplevel, where(ancestry: [nil, ''])

  has_ancestry

  after_create :update_comments_count!

  private

  def update_comments_count!
    if topic.kind_of?(Article) or topic.kind_of?(Poll)
      topic.comments_count = topic.comments.count
      topic.save!
    end
  end
end

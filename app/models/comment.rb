class Comment < ActiveRecord::Base
  paginates_per 5

  validates :author_id, :body, :topic_id, :topic_type, presence: true
  attr_accessible :body, :topic_id, :topic_type, :topic, :ancestry

  belongs_to :topic, polymorphic: true
  belongs_to :author, class_name: 'User'

  scope :toplevel, where(ancestry: [nil, ''])

  has_ancestry

  after_create :update_comments_count!

  validates :state, presence: true
  state_machine :state, initial: :active do
    event :active do
      transition all => :complete
    end

    event :removed_by_owner do
      transition all => :removed_by_owner
    end

    event :removed_by_admin do
      transition all => :removed_by_admin
    end
  end

  store :versions
  def texts_versions
    versions['items'] or []
  end

  def body=(value)
    # old value
    if body.present?
      versions['items'] ||= []
      versions['items'].push({
        body: body,
        edited_at: DateTime.now.to_s
      })
    end
    self[:body] = value
  end

  private

  def update_comments_count!
    if topic.kind_of?(Article) or topic.kind_of?(Poll)
      topic.comments_count = topic.comments.count
      topic.save!
    end
  end
end

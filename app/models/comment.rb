class Comment < ActiveRecord::Base
  paginates_per 5

  validates :author_id, :body, :topic_id, :topic_type, presence: true
  attr_accessible :body, :topic_id, :topic_type, :topic, :ancestry

  belongs_to :topic, polymorphic: true
  belongs_to :author, class_name: 'User'

  scope :newer, order('comments.created_at DESC')
  scope :older, order('comments.created_at ASC')

  scope :toplevel, where(ancestry: [nil, ''])
  scope :active, where(state: 'active')
  scope :removed_by_owner, where(state: 'removed_by_owner')
  scope :removed_by_admin, where(state: 'removed_by_admin')

  has_ancestry

  after_create :update_comments_count!
  after_create :check_notify

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

  def active?
    state == 'active'
  end

  def removed_by_owner?
    state == 'removed_by_owner'
  end

  def removed_by_admin?
    state == 'removed_by_admin'
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

  def owner?(user)
    user.present? and (user.id == author_id)
  end

  private

  def update_comments_count!
    if topic.kind_of?(Article) or topic.kind_of?(Poll)
      topic.comments_count = topic.comments.count
      topic.save!
    end
  end

  def check_notify
    # Comment to article
    comments_user_ids = self.topic.comments.
      joins(:author).
      where('users.active_subscription = ? AND
             users.article_comment_notification = ? AND
             users.id != ? AND
             (users.last_email_article >= ? or users.last_email_article IS NULL)',
      true, true, self.author_id, Time.zone.now.to_s(:db)).map {|c| c.author_id}

    User.find(comments_user_ids).each do |user|
      UserNotifyMailer.comment_in_articles(user, self.topic).deliver
      user.last_email_article!
    end

    # Comment to comment
    return if self.is_root?
    user = self.root.author
    return unless user.active_subscription? && user.comment_notification?
    return if user.last_email_comment.nil? ? false : (user.last_email_comment >= Time.zone.now - 3.hours)
    UserNotifyMailer.comment_comment(user, self.topic).deliver
    user.last_email_comment!
  end

end

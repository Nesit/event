class Article < ActiveRecord::Base
  
  mount_uploader :head_image, ArticleHeadImageUploader
  has_many :galleries, class_name: 'ArticleGallery'

  acts_as_taggable
  attr_accessible :tag_list

  before_validation :ensure_published_date

  validates :title, :body, :short_description, :list_item_description,
            :head_image, :published_at, presence: true
  validates :type, presence: true

  attr_accessible :body, :title, :head_image, :list_item_description,
    :short_description, :target_at, :author_id, :issue_id, :closed,
    :closed_body, :published_at

  has_many :comments, as: :topic
  belongs_to :author, class_name: 'ArticleAuthor'
  belongs_to :issue

  scope :newer, order('articles.created_at DESC')
  scope :older, order('articles.created_at ASC')
  scope :popular, order('articles.pageviews_count DESC')
  scope :without_tv, where('type <> ?', 'TvArticle')

  def record_pageview!
    self.pageviews_count += 1
    save!
  end

  def next_article
    self.class.where('articles.id <> ?', id)
              .where("articles.published_at < ?", published_at).first
  end

  def previous_article
    self.class.where('articles.id <> ?', id)
              .where("articles.published_at > ?", published_at).first
  end

  def closed?
    closed
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private

  def ensure_published_date
    self.published_at ||= DateTime.now
  end
end

class EventArticle < Article
  validates :target_at, presence: true

  scope :newer_targeted, lambda { order('articles.target_at DESC') }
  scope :older_targeted, lambda { order('articles.target_at ASC') }
end

%w[
  CompanyArticle InterviewArticle
  NewsArticle OverviewArticle ReportArticle
  TripArticle
].each do |klass_name|
  klass = Class.new(Article) do
    # methods here
  end
  Object.const_set(klass_name, klass)
end

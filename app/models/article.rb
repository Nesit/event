# encoding: utf-8

class Article < ActiveRecord::Base
  mount_uploader :head_image, ArticleHeadImageUploader
  has_many :galleries, class_name: 'ArticleGallery'

  acts_as_taggable

  before_validation :ensure_published_date

  validates :title, :body, :short_description, :list_item_description,
            :head_image, :published_at, :type, presence: true

  attr_accessible :body, :title, :head_image, :list_item_description,
                  :short_description, :target_at, :author_id, :issue_id, :closed,
                  :closed_body, :published_at, :published, :tag_list

  has_many :comments, as: :topic
  belongs_to :author, class_name: 'ArticleAuthor'
  belongs_to :issue

  scope :newer, order('articles.created_at DESC')
  scope :older, order('articles.created_at ASC')
  scope :newer_published, order('articles.published_at DESC')
  scope :older_published, order('articles.published_at ASC')
  scope :popular, order('articles.pageviews_count DESC')
  scope :without_tv, where('type <> ?', 'TvArticle')
  scope :published, where(published: true)

  scope :published_to_monday, -> { published.where('published_at BETWEEN ? AND ?',
                                   (Time.zone.now.prev_week.monday + 3.days).beginning_of_day, Time.zone.now.monday.end_of_day)
  }

  scope :published_to_thursday, -> { published.where('published_at BETWEEN ? AND ?',
                                   (Time.zone.now.prev_week.monday).beginning_of_day, (Time.zone.now.monday + 3.days).end_of_day)
  }

  extend FriendlyId
  friendly_id :title, use: :slugged

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
  TripArticle DetailArticle
].each do |klass_name|
  klass = Class.new(Article) do
    # methods here
  end
  Object.const_set(klass_name, klass)
end

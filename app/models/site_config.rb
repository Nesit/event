class SiteConfig < ActiveRecord::Base
  validates :actual_article, :actual_article_description, presence: true

  belongs_to :actual_article, class_name: 'Article'

  attr_accessible :actual_article_id, :actual_article_description,
    :article_list_banner_after, :article_list_banner_body
end

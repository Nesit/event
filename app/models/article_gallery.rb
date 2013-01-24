class ArticleGallery < ActiveRecord::Base
  belongs_to :article
  has_many :images, class_name: 'ArticleBodyImage'

  attr_accessible :article_id, :title
end

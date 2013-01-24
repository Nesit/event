class ArticleGallery < ActiveRecord::Base
  belongs_to :article
  has_many :images, class_name: 'ArticleBodyImage'

  attr_accessible :article_id, :title, :images_attributes

  accepts_nested_attributes_for :images
end

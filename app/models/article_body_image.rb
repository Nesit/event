class ArticleBodyImage < ActiveRecord::Base
  mount_uploader :source, ArticleBodyImageUploader
  belongs_to :article_gallery

  attr_accessible :article_gallery_id, :source

  validates :source, :article_gallery_id, presence: true
end

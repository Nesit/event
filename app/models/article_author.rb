class ArticleAuthor < ActiveRecord::Base
  validates :avatar, :name, presence: true

  attr_accessible :avatar, :name

  has_many :articles

  mount_uploader :avatar, AuthorAvatarUploader
end

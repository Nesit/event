class Page < ActiveRecord::Base
  validates :name, :body, presence: true
  attr_accessible :name, :body
end

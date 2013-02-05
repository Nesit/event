class Page < ActiveRecord::Base
  validates :name, :body, presence: true
  attr_accessible :name, :body

  def title
    name
  end
end

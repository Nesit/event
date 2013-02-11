# encoding: utf-8

class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, :body, presence: true
  attr_accessible :name, :body

  def title
    name
  end
end

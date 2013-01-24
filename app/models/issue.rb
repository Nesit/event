# encoding: utf-8

class Issue < ActiveRecord::Base
  validates :cover, :issued_at, :name, :number, presence: true

  attr_accessible :cover, :issued_at, :name, :number

  has_many :articles
  mount_uploader :cover, IssueCoverUploader

  scope :issued_newer, order('issues.issued_at DESC')
  scope :issued_older, order('issues.issued_at ASC')

  def self.current
    issued_newer.first
  end

  def to_s
    Russian.strftime issued_at, "№#{number} (%B) %Y"
  end
end

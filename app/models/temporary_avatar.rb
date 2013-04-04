class TemporaryAvatar < ActiveRecord::Base
  mount_uploader :avatar, TemporaryAvatarUploader

  validates :avatar, presence: true

  attr_accessible :avatar

  def self.cleanup!
    TemporaryAvatar.where('created_at < ?', DateTime.now + 1.day)
      .each(&:destroy)
  end
end

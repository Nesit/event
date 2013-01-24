# encoding: utf-8

class UserAvatarUploader < BasicImageUploader
  process convert: :png

  version :thumb do
    process resize_to_fill: [60, 60]
    process convert: :png
  end

  version :profile do
    process resize_to_fill: [96, 96]
    process convert: :png
  end

  def default_url
    asset_path('no_avatar.png')
  end
end

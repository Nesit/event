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

  # returns new file
  def self.crop_thumbnail_from(x, y, width, height, path)
    image = MiniMagick::Image.open(path)
    image.crop "#{width}x#{height}+#{x}+#{y}"
    file = Tempfile.new(["avatar_thumbnail", File.extname(path)])
    file.binmode
    image.write(file)
    file
  end

  def default_url
    asset_path('no_avatar.png')
  end
end

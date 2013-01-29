# encoding: utf-8

class AuthorAvatarUploader < BasicImageUploader
  process convert: :png
  process resize_to_fill: [96, 96]

  version :thumb do
    process resize_to_fill: [16, 16]
    process convert: :png
  end
end

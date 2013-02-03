# encoding: utf-8

class AuthorAvatarUploader < BasicImageUploader
  process convert: :png

  version :thumb do
    process resize_to_fill: [32, 32]
    process convert: :png
  end
end

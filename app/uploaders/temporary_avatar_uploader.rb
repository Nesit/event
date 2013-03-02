# encoding: utf-8

class TemporaryAvatarUploader < BasicImageUploader
  process resize_to_fit: [768, 768]
  process convert: :png
end

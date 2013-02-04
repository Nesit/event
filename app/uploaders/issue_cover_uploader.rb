# encoding: utf-8

class IssueCoverUploader < BasicImageUploader
  process convert: :png

  version :thumb do
    process resize_to_fill: [200, 283]
    process convert: :png
  end
end

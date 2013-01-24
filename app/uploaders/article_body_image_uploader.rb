# encoding: utf-8

class ArticleBodyImageUploader < BasicImageUploader
  process resize_to_fill: [570, 310]
  process convert: :png
end

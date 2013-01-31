# encoding: utf-8

class ArticleBodyImageUploader < BasicImageUploader
  process resize_to_fill: [575, 384]
  process convert: :png
end

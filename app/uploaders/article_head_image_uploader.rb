# encoding: utf-8

class ArticleHeadImageUploader < BasicImageUploader
  process convert: :png

  version :head do
    process resize_to_fill: [470, 312]
    process convert: :png

    version :carousel do
      process resize_to_fill: [300, 200]
      process convert: :png
    end
  end

  version :popular do
    process resize_to_fill: [106, 71]
    process convert: :png
  end

  version :afisha do
    process resize_to_fill: [155, 82]
    process convert: :png
  end

  version :list_thumb do
    process resize_to_fill: [270, 190]
    process convert: :png
  end

  version :footer do
    process resize_to_fill: [216, 146]
    process convert: :png
  end

  version :video_thumb do
    process resize_to_fill: [199, 133]
    process convert: :png
  end
end

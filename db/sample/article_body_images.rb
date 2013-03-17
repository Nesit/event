[1, 2, 3].each do |id|
  image = ArticleBodyImage.find(id)
  image.source = File.open Rails.root.join("db", "sample", "images", "donkeys", "#{id}.png")
  image.save!
end

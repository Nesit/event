[
  # id of article and image name
  [1, "three.png"],
  [2, "ap.png"],
  [3, "linus.png"],
  [4, "forum.png"],
  [5, "stallman.png"],
  [6, "sting.png"],
  [7, "gunday.png"],
  [8, "zheleznyak.png"],
  [9, "crash.png"],
  [10, "boat.png"],
  [11, "ascii.png"],
  [12, "snow.png"],
  [13, "parlament.png"],
].each do |pair|
  article = Article.find(pair.first)
  article.head_image = File.open Rails.root.join("db", "sample", "images", pair.last)
  article.save!
end

# tv articles
# generate video thumbnails
[
  [14, "f5H35Ak5a2E"],
  [15, "MLzshjaSxmE"],
  [16, "qDO6HV6xTmI"],
].each do |pair|
  article = Article.find(pair.first)
  article.head_video_code = pair.last
  article.save!
end
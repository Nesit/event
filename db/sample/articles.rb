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
  [14, "http://www.youtube.com/watch?v=f5H35Ak5a2E"],
  [15, "http://www.youtube.com/watch?v=MLzshjaSxmE"],
  [16, "https://vimeo.com/58179312"],
].each do |pair|
  article = Article.find(pair.first)
  article.head_video_url = pair.last
  article.save!
end
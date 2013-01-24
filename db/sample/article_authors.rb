author = ArticleAuthor.find(1)
author.avatar = File.open Rails.root.join("db", "sample", "images", "anna.png")
author.save!
author = ArticleAuthor.find(1)
author.avatar = File.open Rails.root.join("db", "sample", "images", "avatar.png")
author.save!
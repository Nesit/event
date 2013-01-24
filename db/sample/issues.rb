issue = Issue.find(1)
issue.cover = File.open Rails.root.join("db", "sample", "images", "grey.png")
issue.save!
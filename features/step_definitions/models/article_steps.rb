Given /^news article is published with$/ do |table|
  FactoryGirl.create(:news_article, table.hashes.first)
end

Given /^news article published$/ do
  FactoryGirl.create(:news_article) unless NewsArticle.scoped.any?
end

Given /^news article published with gallery$/ do
  article = FactoryGirl.create(:news_article, title: "Test title")
  article_gallery = FactoryGirl.create(:article_gallery, article: article)
  FactoryGirl.create(:article_body_image, article_gallery: article_gallery)
end



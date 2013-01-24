Given /^news article is published with$/ do |table|
  FactoryGirl.create(:news_article, table.hashes.first)
end

Given /^news article published$/ do
  FactoryGirl.create(:news_article) unless NewsArticle.scoped.any?
end

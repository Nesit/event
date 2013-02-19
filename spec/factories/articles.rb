# encoding: utf-8

FactoryGirl.define do
  factory :news_article do
    title "Название статьи"
    body "Текст статьи"
    short_description "Краткое описание"
    list_item_description "Краткое описание для отображения в списке"
    head_image { File.open(Rails.root.join("db/sample/images/1px.gif")) }
    type 'NewsArticle'
    published true
  end
end

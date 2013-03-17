# encoding: utf-8

FactoryGirl.define do
  factory :article_body_image do
    source { File.open(Rails.root.join("db/sample/images/image.png")) }
  end
end

FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }

    association :author, factory: :user
    association :topic, factory: :news_article
  end
end

# encoding: utf-8

FactoryGirl.define do
  sequence :user_name do |n|
    "Уникальное имя #{n}"
  end

  sequence :email do |n|
    "unique#{n}@email.com"
  end

  factory :user do
    password "password" # do not change it, this value used in cucumber tests

    factory :user_need_email do
      state 'need_email'
    end

    factory :user_need_info do
      state 'need_info'
      email { generate(:email) }
    end

    factory :user_complete do
      state 'complete'

      email { generate(:email) }
      name { generate(:user_name) }
      city { FactoryGirl.create(:city) }
      born_at DateTime.new(1980)
      gender :male
      company "RSpec & Cucumber"
      position "Tester"
      website "https://www.relishapp.com/"
    end
  end
end

# encoding: utf-8

FactoryGirl.define do
  sequence :city_name do |n|
    "Город в России #{n}"
  end

  factory :city do
    name { generate(:city_name) }
    country :russia
  end
end

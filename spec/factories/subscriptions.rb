# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do

    factory :pending_subscription do
      kind :one_year
      state :pending
    end

    factory :activated_subscription do
      activated_at Date.today
      ended_at (Date.today + 1.year)
      kind :one_year
      state :active
    end
  end
end

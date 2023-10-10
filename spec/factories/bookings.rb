FactoryBot.define do
  factory :booking do
    date { Faker::Date.forward }
    amount { 0 }
    duration { } # Duration in intervals of 15 min
    association :user_owner, factory: :user
    association :user_walker, factory: :user

  end
end
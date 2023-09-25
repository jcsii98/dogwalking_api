FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    confirmed_at { Time.now }
  end
end

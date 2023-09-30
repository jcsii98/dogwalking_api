FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    confirmed_at { Time.now }
    status { 'pending' }
  end
end

FactoryBot.define do
  factory :admin do
    provider { 'email' }
    uid { Faker::Internet.unique.email }
    password { 'password' }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    
  end
end
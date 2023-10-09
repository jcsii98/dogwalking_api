FactoryBot.define do
  factory :user do
    provider { 'email' }
    uid { Faker::Internet.unique.email }
    password { 'password' }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    kind { ['1', '2'].sample }
    status { 'pending' }

  end
end
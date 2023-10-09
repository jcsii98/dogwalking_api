FactoryBot.define do
  factory :dog_profile do
    name { Faker::Name.first_name }
    breed { 'breed' }
    age { rand(1..15) }
    sex { ['Male', 'Female'].sample }
    weight { rand(5..100) }
    user
  end
end
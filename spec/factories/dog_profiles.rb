FactoryBot.define do
  factory :dog_profile do
    association :user, factory: :user
    name { "MyString" }
    breed { "MyString" }
    age { 1 }
    sex { "MyString" }
    weight { 1 }
    hidden { false }
  end
end

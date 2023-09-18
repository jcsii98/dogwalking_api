FactoryBot.define do
  factory :dog_profile do
    name { "MyString" }
    breed { "MyString" }
    age { 1 }
    sex { "MyString" }
    weight { 1 }
    hidden { false }
    user { nil }
  end
end

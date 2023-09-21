FactoryBot.define do
  factory :booking do
    dog_walking_job { nil }
    date { "2023-09-21" }
    amount { "9.99" }
    status { "MyString" }
  end
end

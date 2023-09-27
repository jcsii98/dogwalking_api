FactoryBot.define do
  factory :booking do
    association :dog_walking_job
    association :user, factory: :user
    date { "2023-09-21" }
    status { "MyString" }
  end
end

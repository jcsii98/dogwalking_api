FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    user
    chatroom
  end
end
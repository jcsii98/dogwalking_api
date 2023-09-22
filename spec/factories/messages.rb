FactoryBot.define do
  factory :message do
    content { "MyText" }
    user { nil }
    chatroom { nil }
  end
end

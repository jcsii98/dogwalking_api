FactoryBot.define do
  factory :chatroom do
    association :booking, factory: :booking
  end
end

FactoryBot.define do
  factory :chatroom do
    booking
    walker_user_id { create(:user).id }
    owner_user_id { create(:user).id }
  end
end
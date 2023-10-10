FactoryBot.define do
  factory :booking do
    date { Faker::Date.forward }
    amount {  }
    duration { rand(1..5) * 15 } # Duration in intervals of 15 min
    user_owner_id { create(:user).id }
    user_walker_id { create(:user).id }
    user_owner_name { 'User Owner Name' } # Set the user_owner_name
    user_walker_name { 'User Walker Name' } # Set the user_walker_name
  end
end
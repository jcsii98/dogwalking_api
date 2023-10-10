require 'rails_helper'

RSpec.describe Chatroom, type: :model do
    describe "associations" do 
        it { should belong_to(:booking) }
        it { should have_many(:messages).dependent(:destroy) }
    end

    describe "callbacks" do
       it "sets owner_user_id and walker_user_id before create" do
            user_owner = FactoryBot.create(:user, kind: '2')
            user_walker = FactoryBot.create(:user, kind: '1')
            dog_walking_job = FactoryBot.create(:dog_walking_job, user: user_walker)
            booking = FactoryBot.create(:booking, user_owner: user_owner, user_walker: user_walker)
            chatroom = FactoryBot.create(:chatroom, booking: booking)

            expect(chatroom.booking.user_walker).to eq(user_walker)
            expect(chatroom.booking.user_owner).to eq(user_owner)
       end
    end
end

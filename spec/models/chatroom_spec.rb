require 'rails_helper'

RSpec.describe Chatroom, type: :model do
    describe "associations" do 
        it { should belong_to(:booking) }
        it { should have_many(:messages).dependent(:destroy) }
    end

    describe "callbacks" do
       it "sets owner_user_id and walker_user_id before create" do
            user = FactoryBot.create(:user)
            dog_walking_job = FactoryBot.create(:dog_walking_job, user: user)
            user2 = FactoryBot.create(:user)
            booking = FactoryBot.create(:booking, user: user2, dog_walking_job: dog_walking_job)
            chatroom = FactoryBot.create(:chatroom, booking: booking)

            expect(chatroom.owner_user_id).to eq(user2.id)
            expect(chatroom.walker_user_id).to eq(dog_walking_job.user.id)
       end
    end
end

require 'rails_helper'

RSpec.describe Booking, type: :model do
    describe "associations" do
        it { should belong_to(:user_walker) }
        it { should belong_to(:user_owner) }
        it { should have_many(:booking_dog_profiles).dependent(:destroy) }
        it { should have_many(:dog_profiles).through(:booking_dog_profiles) }
        it { should have_one(:chatroom).dependent(:destroy) }
    end

    describe "callbacks" do
        it "creates a chatroom after create" do
            user_owner = FactoryBot.create(:user, kind: '2')
            user_walker = FactoryBot.create(:user, kind: '1')
            dog_walking_job = FactoryBot.create(:dog_walking_job, user: user_walker)
            booking = FactoryBot.create(:booking, user_walker: user_walker, user_owner: user_owner)
            expect(booking.chatroom).to be_present
        end

        it "calculates billing amount before save" do
        user_owner = FactoryBot.create(:user, kind: '2')
        user_walker = FactoryBot.create(:user, kind: '1')
        job = FactoryBot.create(:dog_walking_job, wgr1: 10, wgr2: 20, wgr3: 30, user: user_walker)
        booking = FactoryBot.create(:booking, user_owner: user_owner, user_walker: user_walker, duration: 2)

        light_dog = FactoryBot.create(:dog_profile, user: user_owner, weight: 15) 
        medium_dog = FactoryBot.create(:dog_profile, user: user_owner, weight: 25) 
        heavy_dog = FactoryBot.create(:dog_profile, user: user_owner, weight: 65)  

        FactoryBot.create(:booking_dog_profile, booking_id: booking.id, dog_profile: light_dog)
        FactoryBot.create(:booking_dog_profile, booking_id: booking.id, dog_profile: medium_dog)
        FactoryBot.create(:booking_dog_profile, booking_id: booking.id, dog_profile: heavy_dog)
        
        booking.save!
        booking.reload


        expected_amount = 120
        expect(booking.amount).to eq(expected_amount)
        expect(booking.amount).to be_present
        expect(booking.chatroom).to be_present
        end
    end

end

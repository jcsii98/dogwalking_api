require 'rails_helper'

RSpec.describe Booking, type: :model do
    describe "associations" do
        it { should belong_to(:dog_walking_job) }
        it { should belong_to(:user) }
        it { should have_many(:booking_dog_profiles).dependent(:destroy) }
        it { should have_many(:dog_profiles).through(:booking_dog_profiles) }
        it { should have_one(:chatroom).dependent(:destroy) }
    end

    describe "callbacks" do
        it "creates a chatroom after create" do
            user = FactoryBot.create(:user)
            booking = FactoryBot.create(:booking)
            expect(booking.chatroom).to be_present
        end

        it "calculates billing amount before save" do
        user = FactoryBot.create(:user)
        job = FactoryBot.create(:dog_walking_job, wgr1: 10, wgr2: 20, wgr3: 30)
        booking = FactoryBot.build(:booking, user: user, dog_walking_job: job, duration: 2)

        light_dog = FactoryBot.create(:dog_profile, user: user, weight: 15) 
        medium_dog = FactoryBot.create(:dog_profile, user: user, weight: 25) 
        heavy_dog = FactoryBot.create(:dog_profile, user: user, weight: 65)  

        FactoryBot.create(:booking_dog_profile, booking: booking, dog_profile: light_dog)
        FactoryBot.create(:booking_dog_profile, booking: booking, dog_profile: medium_dog)
        FactoryBot.create(:booking_dog_profile, booking: booking, dog_profile: heavy_dog)
        
        booking.save!
        booking.reload


        expected_amount = 120
        expect(booking.amount).to eq(expected_amount)
        expect(booking.amount).to be_present
        expect(booking.chatroom).to be_present
        end
    end

end

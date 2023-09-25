require 'rails_helper'

RSpec.describe BookingDogProfile, type: :model do
    describe "associations" do
        it { should belong_to(:booking) }
        it { should belong_to(:dog_profile) }
    end
end

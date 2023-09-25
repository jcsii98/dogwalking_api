require 'rails_helper'

RSpec.describe DogWalkingJob, type: :model do
    describe "associations" do
        it { should belong_to(:user) }
        it { should have_many(:schedules) }
        it { should have_many(:bookings) }
    end
end

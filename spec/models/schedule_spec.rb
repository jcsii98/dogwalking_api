# require 'rails_helper'

# RSpec.describe Schedule, type: :model do
#     describe "associations" do
#         it { should belong_to(:dog_walking_job) }
#     end

#     describe "validations" do
#         it "validates uniqueness of day scoped to dog_walking_job_id" do

#         user = FactoryBot.create(:user)
#         dog_walking_job = FactoryBot.create(:dog_walking_job, user: user)
#         schedule = FactoryBot.create(:schedule, dog_walking_job: dog_walking_job, day: 1)

#         duplicate_schedule = Schedule.new(dog_walking_job: dog_walking_job, day: 1)

#         expect(duplicate_schedule).not_to be_valid
#         end

#         it { should validate_inclusion_of(:day).in_range(1..7) }
#     end
# end

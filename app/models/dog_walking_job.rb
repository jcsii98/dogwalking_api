class DogWalkingJob < ApplicationRecord
    belongs_to :user
    has_many :schedules
    has_many :bookings

end

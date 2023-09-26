class DogWalkingJob < ApplicationRecord
    belongs_to :user
    has_many :schedules
    has_many :bookings

    validates :name, presence: true
    validates :wgr1, presence: true
    validates :wgr2, presence: true
    validates :wgr3, presence: true
end

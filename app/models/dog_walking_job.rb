class DogWalkingJob < ApplicationRecord
    belongs_to :user
    has_many :schedules

    after_update :recalculate_bookings_amount

    validates :name, presence: true
    validates :wgr1, numericality: { only_integer: true }, allow_blank: true
    validates :wgr2, numericality: { only_integer: true }, allow_blank: true
    validates :wgr3, numericality: { only_integer: true }, allow_blank: true

    private

    def recalculate_bookings_amount
        user.walker_bookings.each do |booking|
            booking.send(:calculate_billing_amount)
            booking.save
        end
    end
end

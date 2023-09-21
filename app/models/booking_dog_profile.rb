class BookingDogProfile < ApplicationRecord
  belongs_to :booking
  belongs_to :dog_profile
end

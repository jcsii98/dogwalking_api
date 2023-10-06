class BookingDogProfile < ApplicationRecord
  belongs_to :booking
  belongs_to :dog_profile

  validate :dog_profile_exists

  private

  def dog_profile_exists
    unless DogProfile.exists?(self.dog_profile_id)
      errors.add(:dog_profile, "with id #{self.dog_profile_id} does not exist")
    end
  end
end

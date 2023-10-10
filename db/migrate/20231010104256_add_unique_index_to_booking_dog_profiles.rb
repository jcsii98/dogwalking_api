class AddUniqueIndexToBookingDogProfiles < ActiveRecord::Migration[7.0]
  def change
    add_index :booking_dog_profiles, [:booking_id, :dog_profile_id], unique: true
  end
end

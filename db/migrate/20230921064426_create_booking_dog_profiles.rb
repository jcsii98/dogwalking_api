class CreateBookingDogProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_dog_profiles do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :dog_profile, null: false, foreign_key: true

      t.boolean :archived, default: false
      t.timestamps
    end
  end
end

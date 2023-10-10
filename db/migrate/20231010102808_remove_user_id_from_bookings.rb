class RemoveUserIdFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bookings, :user, index: true, foreign_key: true
  end
end

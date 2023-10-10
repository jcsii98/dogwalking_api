class RemoveColumnsFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :user_owner_name
    remove_column :bookings, :user_walker_name

  end
end

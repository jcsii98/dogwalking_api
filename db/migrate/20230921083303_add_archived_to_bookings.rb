class AddArchivedToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :archived, :boolean, default: false
  end
end

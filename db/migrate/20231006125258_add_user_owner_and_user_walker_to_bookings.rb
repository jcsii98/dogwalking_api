class AddUserOwnerAndUserWalkerToBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :user_owner, null: false, foreign_key: { to_table: :users }
    add_reference :bookings, :user_walker, null: false, foreign_key: { to_table: :users }
    add_column :bookings, :user_owner_name, :string, null: false
    add_column :bookings, :user_walker_name, :string, null: false
  end
end

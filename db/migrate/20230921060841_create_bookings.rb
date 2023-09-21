class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :dog_walking_job, null: false, foreign_key: true
      
      t.date :date
      t.decimal :amount
      t.string :status

      t.timestamps
    end
  end
end

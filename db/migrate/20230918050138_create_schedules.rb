class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :dog_walking_job, null: false, foreign_key: true
      t.integer :day
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end

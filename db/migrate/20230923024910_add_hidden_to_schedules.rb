class AddHiddenToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :hidden, :boolean
  end
end

class AddArchivedToDogWalkingJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :dog_walking_jobs, :archived, :boolean
  end
end

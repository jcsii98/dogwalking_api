class CreateDogWalkingJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :dog_walking_jobs do |t|
      t.string :name
      t.integer :wgr1
      t.integer :wgr2
      t.integer :wgr3
      t.boolean :hidden

      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end

class CreateDogProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :dog_profiles do |t|
      t.string :name
      t.string :breed
      t.integer :age
      t.string :sex
      t.integer :weight
      t.boolean :hidden
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

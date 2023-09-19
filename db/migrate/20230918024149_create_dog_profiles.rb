class CreateDogProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :dog_profiles do |t|
      t.text :name
      t.text :breed
      t.integer :age
      t.text :sex
      t.integer :weight
      t.boolean :hidden

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

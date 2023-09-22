class CreateChatrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chatrooms do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :walker_user, foreign_key: { to_table: :users }
      t.references :owner_user, foreign_key: { to_table: :users }
      
      t.timestamps
    end
  end
end

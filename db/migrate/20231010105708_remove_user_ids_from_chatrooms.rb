class RemoveUserIdsFromChatrooms < ActiveRecord::Migration[7.0]
  def change
    remove_column :chatrooms, :owner_user_id
    remove_column :chatrooms, :walker_user_id
  end
end

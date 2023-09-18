class AddArchivedToDogProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :dog_profiles, :archived, :boolean, default: false
  end
end

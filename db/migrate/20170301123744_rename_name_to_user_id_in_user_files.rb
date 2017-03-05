class RenameNameToUserIdInUserFiles < ActiveRecord::Migration[5.0]
  def change
    rename_column :user_files, :name, :user_id
  end
end

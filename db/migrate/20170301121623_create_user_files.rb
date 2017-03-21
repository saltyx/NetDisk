 class CreateUserFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_files do |t|
      t.string :name
      t.string :file_name
      t.float :file_size
      t.string :file_path
      t.boolean :is_folder
      t.integer :from_folder
      t.boolean :is_shared
      t.boolean :is_encrypted
      t.string :download_link
      t.integer :download_times

      t.timestamps
    end
  end
end

class AddIvToUserFile < ActiveRecord::Migration[5.0]
  def change
    add_column :user_files, :iv, :string
  end
end

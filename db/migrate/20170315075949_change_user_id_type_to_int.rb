class ChangeUserIdTypeToInt < ActiveRecord::Migration[5.0]
  def change
    change_column :user_files, :user_id, :integer
  end
end

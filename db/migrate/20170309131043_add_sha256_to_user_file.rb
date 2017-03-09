class AddSha256ToUserFile < ActiveRecord::Migration[5.0]
  def change
    add_column :user_files, :sha256, :string
  end
end

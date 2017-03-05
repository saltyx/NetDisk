class RenameLastLoginTimToLastLoginTime < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :last_login_tim, :last_login_time
  end
end

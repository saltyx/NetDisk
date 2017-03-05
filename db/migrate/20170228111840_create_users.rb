class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.boolean :is_admin
      t.string :last_login_ip
      t.datetime :last_login_tim
      t.string :last_login_device
      t.float :total_storage
      t.float :used_storage
      t.string :password_digest

      t.timestamps
    end
  end
end

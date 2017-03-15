# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(:name => 'test', :email => 'test@test.com', :password => '123', :is_admin => true,
             :last_login_ip => '0.0.0.0', :last_login_time => '2017/2/28', :total_storage => 100000000, :used_storage => 0)

UserFile.create!(:user_id => 1,:file_name => 'root', :is_folder => true, :is_encrypted => false)
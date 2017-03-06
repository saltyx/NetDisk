class UserFile < ApplicationRecord

  belongs_to :user,:class_name => 'User', :foreign_key => :user_id

  validates_presence_of :user_id
  validates_presence_of :file_name

  before_create :b_create
  after_save :a_save
  before_destroy :b_destroy

  def b_create
    self.is_shared= false
    self.download_times= 0
    self.is_encrypted= false
  end

  def a_save
    $redis.keys("folder##{self.user_id}#*") do |key|
      $redis.del key
    end

    $redis.keys("files##{self.user_id}#*") do |key|
      $redis.del key
    end

  end

  def b_destroy
    if self.is_folder
      #删除目录下的所有文件
      files = UserFile.find_by_from_folder(self.id)
      files.destroy unless files.nil?
    else
      #不是目录更新user used_storage
      user = User.find(self.user_id)
      user.used_storage = user.used_storage - self.file_size
      user.save
    end
  end

end

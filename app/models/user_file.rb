class UserFile < ApplicationRecord

  belongs_to :user,:class_name => 'User', :foreign_key => :user_id

  validates_presence_of :user_id
  validates_presence_of :file_name

  before_create :b_create

  def b_create
    # before saving
    self.is_shared= false
    self.download_times= 0
    self.is_encrypted= false
  end

  def self.find_the_file (from_folder, file_name)
    files = UserFile.where('from_folder = ? and file_name = ?', from_folder, file_name)
    if files.blank?
      nil
    else
      files.first!
    end
  end

end

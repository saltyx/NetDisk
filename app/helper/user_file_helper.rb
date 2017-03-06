
module UserFileHelper

  def self.fetch_files_by_folder (folder_id, user_id)
    UserFile.where('user_id = ? and from_folder = ?', user_id, folder_id)
  end

  def self.get_folder_info (folder_id, user_id)
    UserFile.where('user_id = ? and id = ? and is_folder = ?', user_id, folder_id, true).first!
  end

  def self.get_the_file (folder_id, file_name, user_id)
    files = UserFile.where('user_id = ? and from_folder = ? and file_name = ?',user_id, folder_id, file_name)
    return nil if files.nil? || files.blank?
    files.first!
  end

  def self.get_the_folder (from_folder, folder_name,user_id)
    folder = UserFile.where('user_id = ? and from_folder = ? and file_name = ? and is_folder = ?',
                          user_id, from_folder, folder_name, true)
    return nil if folder.nil? || folder.blank?
    folder.first!
  end

  def self.get_the_file_by_id(file_id, user_id)
    file = UserFile.where('user_id = ? and id = ? ', user_id, file_id)
    return nil if file.nil? || file.blank?
    file.first!
  end

end
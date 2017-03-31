
module UserFileHelper

  include EncryptHelper

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
    file = UserFile.where('user_id = ? and id = ? and is_folder = ?', user_id, file_id,false)
    return nil if file.nil? || file.blank?
    file.first!
  end

  def self.encrypt_file(file_id, user_id, pass_phrase)
    file = get_the_file_by_id(file_id, user_id)
    return -1 if file.nil?
    path = file.file_path
    iv = EncryptHelper.encrypt(path, pass_phrase)
    return -2 if iv.nil? || iv.blank?
    file.iv = iv[0]
    file.is_encrypted = true
    file.save
    0
  end

  def self.decrypt_file(file_id, user_id, pass_phrase)
    file = get_the_file_by_id(file_id, user_id)
    return -1 if file.nil?
    path = file.file_path
    iv = file.iv
    file.is_encrypted = false
    result = EncryptHelper.decrypt(path, iv, pass_phrase)
    if result
      file.save
    end
    result
  end

  def self.encrypt_folder(folder_id, user_id)
    folder = get_folder_info folder_id, user_id
    folder.is_encrypted = true
    folder.save
  end

  def self.decrypt_folder(folder_id, user_id)
    folder = get_folder_info folder_id, user_id
    folder.is_encrypted = false
    folder.save
  end

end
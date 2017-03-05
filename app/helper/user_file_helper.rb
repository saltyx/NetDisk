module UserFileHelper

  def fetch_files_by_folder (folder_id)
    key = "files##{folder_id}"
    files = $redis.get(key)

    if files.nil? || files.blank?
      files = UserFile.find_by_from_folder(key)
      if !files.nil? && !files.blank?
        $redis.set(key, files)
      end
    end
    files
  end

  def get_folder_info (folder_id)

  end

end
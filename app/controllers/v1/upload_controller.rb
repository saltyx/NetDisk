class V1::UploadController < V1::BaseController

  include UserFileHelper

  before_action :authenticate_user!

  def upload

    filesize = upload_param[:filesize].to_i
    filename = check_storage?(upload_param[:file], filesize)
    folder_id = upload_param[:id]

    dir = "#{Rails.root}/disk/#{current_user.name}/"
    Dir.mkdir dir unless Dir.exists? dir

    return not_enough_space if filename.nil?
    return folder_not_exist unless folder_exits? folder_id

    unchecked_file = UserFileHelper.get_the_file(folder_id, filename, current_user.id)
    unchecked_used_storage = current_user.used_storage

    if unchecked_file.nil?
      #未找到文件则插入该文件
      if current_user.total_storage < unchecked_used_storage+filesize
        not_enough_space
        return
      end

      dir = dir.concat "#{get_timestamp}/"
      Dir.mkdir dir
      path = dir.concat filename

      File.open(path, 'wb') do |f|
        f.write upload_param[:file].read
      end

      current_user.used_storage = unchecked_used_storage+filesize
      current_user.save!

      file = UserFile.create(user_id: current_user.id, from_folder: folder_id,file_size: filesize,
                       file_name: filename, is_folder: false, file_path: path)

      response_status(200, file.id)
    else
      # 更新文件

      if current_user.total_storage < unchecked_used_storage-unchecked_file.file_size+filesize
        not_enough_space
        return
      end

      path = unchecked_file.file_path

      File.open(path, 'wb') do |f|
        f.write upload_param[:file].read
      end

      current_user.used_storage = unchecked_used_storage-unchecked_file.file_size+filesize
      current_user.save!

      unchecked_file.file_size = filesize
      unchecked_file.save!

      response_status(200, unchecked_file.id)
    end
  end

  def upload_big_file

    dir = "#{Rails.root}/disk/#{current_user.name}/"
    Dir.mkdir dir unless Dir.exists? dir

    return params_error if big_file_param[:id].nil? || big_file_param[:filesize].nil? ||
                        big_file_param[:filename].nil? || big_file_param[:chunks].nil? ||
                        big_file_param[:chunk_index].nil?

    folder_id = big_file_param[:id].to_i
    file_size = big_file_param[:filesize].to_i
    file_name = big_file_param[:filename].to_s
    total_chunks = big_file_param[:chunks].to_i #总分片数
    chunk_index = big_file_param[:chunk_index].to_i #当前分片的序号

    return not_enough_space if current_user.total_storage < current_user.used_storage + file_size
    return folder_not_exist unless folder_exits?(folder_id)

    key = "#{file_name}##{folder_id}"
    unchecked_index = $redis.get key

    if unchecked_index.nil?
      # redis中不存在数据则加入
      path = dir.concat "#{get_timestamp}/"
      Dir.mkdir path
      path = path.concat file_name

      if chunk_index == 1
        File.open(path, 'ab+') do |f|
          f.write params[:file].read
        end
        $redis.set(key, chunk_index)
        response_status(200, 'ok')
      else
        unsafe_status
      end

    else
      file = UserFileHelper.get_the_file(folder_id, file_name, current_user.id)
      return unsafe_status if file.nil?

      path = file.file_path

      #redis中存在下标则检查
      if chunk_index == unchecked_index+1
        # accept the status
        File.open(path, 'ab+') do |f|
          f.write params[:file].read
        end

        if chunk_index == total_chunks
          #最后一片
          current_user.used_storage = current_user.used_storage+file_size
          current_user.save
          $redis.del key
        else
          $redis.set(key, chunk_index)
        end

        response_status(200, 'ok')
      else
        unsafe_status
      end

    end

  end

  private

  def upload_param
    params.permit(:id,:file,:filesize)
  end

  def big_file_param
    params.permit(:id, :file,:filename ,:filesize, :chunks,:chunk_index)
  end

  def check_storage? (file, filesize)
    if !current_user.nil? && current_user.total_storage >= (current_user.used_storage+filesize)
      file.original_filename
    else
      nil
    end
  end

  def folder_exits? (folder_id)
    !UserFileHelper.get_folder_info(folder_id, current_user.id).nil?
  end

  def get_timestamp
    Time.now.to_i.to_s
  end

end

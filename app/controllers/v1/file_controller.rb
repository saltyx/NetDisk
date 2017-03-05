class V1::FileController < V1::BaseController

  include UserFileHelper

  before_action :authenticate_user!

  def upload
    logger.info params[:id]
    logger.info params[:filesize]
    filesize = file_param[:filesize].to_i
    filename = check_storage?(file_param[:file], filesize)
    folder_id = params[:id]
    logger.info current_user.id

    dir = "#{Rails.root}/disk/#{current_user.name}/"
    Dir.mkdir(dir) unless Dir.exists?(dir)
    dir = Dir.mkdir("#{dir}/#{get_timestamp}/")
    if !filename.nil? && folder_exits?(params[:id])

      unchecked_file = UserFile.find_the_file(folder_id, filename)
      unchecked_used_storage = current_user.used_storage

      if unchecked_file.nil?
        #未找到文件则插入该文件
        if current_user.total_storage < unchecked_used_storage+filesize
          not_enough_space
          return
        end

        File.open(dir + filename, 'wb') do |f|
          f.write(params[:file].read)
        end

        current_user.used_storage = unchecked_used_storage+filesize
        current_user.save!

        file = UserFile.create(user_id: current_user.id, from_folder: folder_id,file_size: filesize,
                         file_name: filename, is_folder: false, file_path: dir+filename)

        response_status(200, file.id)
      else
        # 更新文件
        if current_user.total_storage < unchecked_used_storage-unchecked_file.file_size+filesize
          not_enough_space
          return
        end

        File.open(dir + filename, 'wb') do |f|
          f.write(params[:file].read)
        end

        current_user.used_storage = unchecked_used_storage-unchecked_file.file_size+filesize
        current_user.save!

        unchecked_file.file_size = filesize
        unchecked_file.save!

        response_status(200, unchecked_file.id)
      end
    else
      folder_not_exist
    end
  end

  def upload_big_file
    folder_id = big_file_param[:id].to_i
    file_size = big_file_param[:filesize].to_i
    file_name = big_file_param[:filename].to_s
    total_chunks = big_file_param[:chunks].to_i #总分片数
    chunk_index = big_file_param[:chunk_index].to_i #当前分片的序号

    if !file_name.nil? && folder_exits?(folder_id)
      key = "#{file_name}##{folder_id}"
      unchecked_index = $redis.get(key)

      if unchecked_index.nil?
        # uncheck index is null
        if chunk_index == 1
          # accept the status

          $redis.set(key, chunk_index)
        else
          unsafe_status
        end
      else
        if chunk_index == unchecked_index+1
          # accept the status

          $redis.set(key, chunk_index)
        else
          unsafe_status
        end

      end

    else
      folder_not_exist
    end

  end

  private

  def file_param
    params.permit(:id,:file,:filesize)
  end

  def big_file_param
    params.permit(:id, :file,:filename ,:filesize, :chunks,:chunk_index)
  end

  def write_chunk_file(file)

  end

  def check_storage? (file, filesize)
    if !current_user.nil? && current_user.total_storage >= (current_user.used_storage+filesize)
      file.original_filename
    else
      nil
    end
  end

  def folder_exits? (folder_id)
    !UserFile.find_by(id: folder_id).nil?
  end

  def not_enough_space
    error(401, 'not enough space')
  end

  def folder_not_exist
    error(401, 'folder not exist')
  end

  def unsafe_status
    error(401, 'unsafe status')
  end

  def get_timestamp
    Time.now.to_i
  end

end

class V1::FileController < V1::BaseController
  include UserFileHelper

  before_action :authenticate_user!

  def encrypt
    id = encrypt_params[:id].to_i
    pass_phrase = encrypt_params[:pass_phrase].to_s

    code = UserFileHelper.encrypt_file(id, current_user.id, pass_phrase)
    file_not_exist if code == -1
    encrypt_error if code == -2
    ok
  end

  def decrypt
    id = encrypt_params[:id].to_i
    pass_phrase = encrypt_params[:pass_phrase].to_s
    return decrypt_error unless UserFileHelper.decrypt_file(id, current_user.id, pass_phrase)
    ok
  end

  def copy
    file = UserFileHelper.get_the_file_by_id(copy_params[:id], current_user.id)
    folder = UserFileHelper.get_folder_info(copy_params[:dst_folder_id], current_user.id)
    return file_not_exist if file.nil?
    return folder_not_exist if folder.nil?
    return not_enough_space if current_user.total_storage < file.file_size+current_user.used_storage
    UserFile.create(user_id: file.user_id, file_name: file.file_name, file_size: file.file_size,
                    file_path: file.file_path, is_encrypted: false, is_shared: false,is_folder: false,
                    from_folder: folder.id)
    current_user.used_storage = current_user.used_storage + file.file_size
    current_user.save
    ok
  end

  def delete
    file = UserFileHelper.get_the_file_by_id(delete_params[:id], current_user.id)
    return file_not_exist if file.nil?
    file.destroy
    ok
  end

  def move
    file = UserFileHelper.get_the_file_by_id(move_params[:id], current_user.id)
    folder = UserFileHelper.get_folder_info(move_params[:dst_folder_id], current_user.id)
    return file_not_exist if file.nil?
    return folder_not_exist if folder.nil?
    file.from_folder = folder.id
    file.save
    ok
  end

  def update
    file = UserFileHelper.get_the_file_by_id(update_params[:id], current_user.id)
    new_name = update_params[:new_name].to_s
    return file_not_exist if file.nil?
    dir = File.dirname(file.file_path).concat("/#{new_name}")
    logger.info dir
    File.rename(file.file_path, dir)
    file.file_name = new_name
    file.file_path = dir
    file.save
    ok
  end

  def share
    file = UserFileHelper.get_the_file_by_id(share_params[:id], current_user.id)
    return file_not_exist if file.nil?
    file.is_shared= true
    file.save
    ok
  end

  def cancel_sharing
    file = UserFileHelper.get_the_file_by_id(share_params[:id], current_user.id)
    return file_not_exist if file.nil?
    file.is_shared= false
    file.save
    ok
  end

  def get_the_file
    file = UserFileHelper.get_the_file_by_id(params[:id], current_user.id)
    if file.nil?
      file_not_exist
    else
      send_file (file.file_path)
    end
  end

  private

  def update_params
    params.require(:file).permit(:new_name, :id)
  end

  def move_params
    params.require(:file).permit(:id, :dst_folder_id)
  end

  def delete_params
    params.require(:file).permit(:id)
  end

  def copy_params
    params.require(:file).permit(:id, :dst_folder_id)
  end

  def encrypt_params
    params.require(:file).permit(:id, :pass_phrase)
  end

  def share_params
    params.require(:file).permit(:id)
  end

end

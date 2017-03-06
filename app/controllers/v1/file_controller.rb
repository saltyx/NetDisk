class V1::FileController < V1::BaseController
  include UserFileHelper

  before_action :authenticate_user!

  def encrypt

  end

  def copy
    file = UserFileHelper.get_the_file_by_id(copy_params[:id], current_user.id)
    folder = UserFileHelper.get_folder_info(copy_params[:dst_folder_id], current_user.id)
    return file_not_exist if file.nil?
    return folder_not_exist if folder.nil?
    return not_enough_space if current_user.total_storage < file.file_size+current_user.used_storage
    UserFile.create(user_id: file.user_id, file_name: file.file_name, file_size: file.file_size,
                    file_path: file.file_path, is_encrypted: false, is_shared: false,
                    from_folder: folder.id)
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
    return file_not_exist if file.nil?
    file.file_name = update_params[:new_name].to_s
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

  def share_params
    params.require(:file).permit(:id)
  end

end

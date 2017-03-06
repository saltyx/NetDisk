class V1::FolderController < V1::BaseController
  include UserFileHelper
  before_action :authenticate_user!

  def create
    folder_name = create_folder_params[:folder_name].to_s
    from_folder = create_folder_params[:from_folder].to_i
    return folder_exist if folder_exits?(folder_name, from_folder)

    folder = UserFile.create(user_id: current_user.id, from_folder: from_folder,
                          is_folder: true, file_name: folder_name)
    response_status(200, folder.id)
  end

  def delete
    folder_id = delete_folder_params[:folder_id].to_i
    folder = UserFileHelper.get_folder_info(folder_id, current_user.id)
    return folder_not_exist if folder.nil?
    folder.destroy
    response_status(200,'ok')
  end

  def update
    folder_name = update_folder_params[:new_name].to_s
    folder_id = update_folder_params[:folder_id].to_i
    folder = UserFileHelper.get_folder_info(folder_id, current_user.id)
    return folder_not_exist if folder.nil?
    folder.file_name = folder_name
    folder.save!
    response_status(200, 'ok')
  end

  def files_by_folder
    folder_id = get_files_params[:id]
    files = UserFileHelper.fetch_files_by_folder(folder_id, current_user.id)
    return folder_not_exist if UserFileHelper.get_folder_info(folder_id, current_user.id).nil?
    response_status(200, files.to_json)
  end

  def encrypt

  end

  private

  def create_folder_params
    params.require(:folder).permit(:folder_name, :from_folder)
  end

  def delete_folder_params
    params.require(:folder).permit(:folder_id)
  end

  def update_folder_params
    params.require(:folder).permit(:new_name,:folder_id)
  end

  def get_files_params
    params.permit(:id)
  end

  def folder_exits? (folder_name, from_folder)
    !UserFileHelper.get_the_folder(from_folder, folder_name, current_user.id).nil?
  end

end

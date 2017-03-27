class V1::FolderController < V1::BaseController
  include UserFileHelper
  before_action :authenticate_user!

  def create
    folder_name = create_folder_params[:folder_name].to_s
    from_folder = create_folder_params[:from_folder].to_i
    return folder_exist if folder_exits?(folder_name, from_folder)

    folder = UserFile.create(user_id: current_user.id, from_folder: from_folder, file_size: 0,
                          is_folder: true, file_name: folder_name)
    response_status(200, folder.id)
  end

  def delete
    folder_id = delete_folder_params[:folder_id].to_i
    folder = UserFileHelper.get_folder_info(folder_id, current_user.id)
    return folder_not_exist if folder.nil?
    folder.destroy
    ok
  end

  def update
    folder_name = update_folder_params[:new_name].to_s
    folder_id = update_folder_params[:folder_id].to_i
    folder = UserFileHelper.get_folder_info(folder_id, current_user.id)
    return folder_not_exist if folder.nil?
    folder.file_name = folder_name
    folder.save!
    ok
  end

  def files_by_folder
    folder_id = get_files_params[:id]
    files = UserFileHelper.fetch_files_by_folder(folder_id, current_user.id)
    return folder_not_exist if files.nil?
    response_status(200, files.to_json)
  end

  def encrypt
    folder_id = encrypt_folder_params[:folder_id].to_i
    pass_phrase = encrypt_folder_params[:pass_phrase].to_s
    user_id = current_user.id
    files = UserFileHelper.fetch_files_by_folder(folder_id, user_id)
    return folder_not_exist if files.nil?
    result = []
    files.each do |f|
      code = 0
      code = UserFileHelper.encrypt_file(f.id, user_id, pass_phrase)
      result.append f.id if code != 0
    end
    return ok if result.blank?
    response_status(401, result.to_json)
  end

  def decrypt
    folder_id = encrypt_folder_params[:folder_id].to_i
    pass_phrase = encrypt_folder_params[:pass_phrase].to_s
    user_id = current_user.id
    files = UserFileHelper.fetch_files_by_folder(folder_id, user_id)
    return folder_not_exist if files.nil?
    result = []
    files.each do |f|
      result.append(f.id) unless UserFileHelper.encrypt_file(f.id, user_id, pass_phrase)
    end
    return ok if result.blank?
    response_status(401, result.to_json)
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

  def encrypt_folder_params
    params.require(:folder).permit(:folder_id, :pass_phrase)
  end

  def get_files_params
    params.permit(:id)
  end

  def folder_exits? (folder_name, from_folder)
    !UserFileHelper.get_the_folder(from_folder, folder_name, current_user.id).nil?
  end

end

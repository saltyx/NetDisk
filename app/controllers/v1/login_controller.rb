
class V1::LoginController < V1::BaseController

  def index

    @user = User.find_by(name: login_params[:name])

    if !@user.nil? && @user.authenticate(login_params[:password])
      @user = User.update(@user.id, last_login_ip: request.remote_ip)
      render :json => UsersSerializer.new(@user.id)
    else
      api_error(status: 401)
    end

  end

  private

  def login_params
    params.require(:user).permit(:name, :password)
  end

end

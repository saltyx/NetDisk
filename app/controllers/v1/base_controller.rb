class V1::BaseController < ApplicationController
  include Pundit
  attr_accessor :current_user

  def api_error(opts = {})
    head(opts[:status])
  end

  def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    user = User.find_by_token(token)

    if !user.nil? && ActiveSupport::SecurityUtils.secure_compare(user.token, token)
      self.current_user = user
    else
      unauthenticated!
    end
  end

  def unauthenticated!
    api_error(status: 401)
  end

  def error(code, msg)
    render json: {error: code, info: msg}
  end

  def response_status(code, msg)
    render json: {success: code, info: msg}
  end

end

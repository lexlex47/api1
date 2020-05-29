class ApplicationController < ActionController::API

  class AuthorizationError < StandardError; end

  # 写在这所有的controller都可以使用
  # 如果有报错则被使用，resuce_from是一种catch excption的方法
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  # 在这里先call
  before_action :authorize!

  private

  # 检测是否需要报错
  def authorize!
    # 只有在没有current_user的情况下报错
    raise AuthorizationError unless current_user
  end

  def access_token
    # 因为Bearer返回的值前面会加“Bearer *****”，
    # 只需要后半部分，
    # 所以使用正则公示， 查找 Bearer开头，同时后面跟着空格的字符，使用‘’进行移除替换，
    # 同时使用ruby安全符号&，如果值为nil则不会报错，返回nil
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  # 返回error如果perfom有错
  def authentication_error 
    error = {
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" => "Authentication code is invalid",
      "detail" => "You must provide valid code in order to exchange it for token."
      }
    render json: {"errors": [ error ] }, status: 401
  end

  # 为destroy准备的测试error json
  def authorization_error
    error = {
      "status" => "403",
      # 一般返回的403都会在header
      "source" => { "pointer" => "/headers/authorization" },
      "title" => "Not authorized",
      "detail" => "You have no right to access this resources."
      }
    render json: {"errors": [ error ] }, status: 403
  end

end

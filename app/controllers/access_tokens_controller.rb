class AccessTokensController < ApplicationController

# 在这里skip，这样的话更加安全
skip_before_action :authorize!, only: :create

# # 如果有报错则被使用，resuce_from是一种catch excption的方法
# rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    render json: authenticator.access_token, status: :created
  end

  def destroy
    # 移除token
    current_user.access_token.destroy
  end

  private

  #  # 返回error如果perfom有错
  # def authentication_error 
  #     error = {
  #       "status" => "401",
  #       "source" => { "pointer" => "/code" },
  #       "title" => "Authentication code is invalid",
  #       "detail" => "You must provide valid code in order to exchange it for token."
  #       }
  #     render json: {"errors": [error] }, status: 401
  # end
end

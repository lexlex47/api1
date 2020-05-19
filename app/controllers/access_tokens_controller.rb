class AccessTokensController < ApplicationController

# 如果有报错则被使用，resuce_from是一种catch excption的方法
rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
  end

  private

   # 返回error如果perfom有错
  def authentication_error 
      error = {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" => "Authentication code is invalid",
        "detail" => "You must provide valid code in order to exchange it for token."
        }
      render json: {"errors": [error] }, status: 401
  end
end

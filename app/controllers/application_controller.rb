class ApplicationController < ActionController::API

# 写在这所有的controller都可以使用
# 如果有报错则被使用，resuce_from是一种catch excption的方法
rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

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

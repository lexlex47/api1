# 用户验证, 所有的文件在app中才会被初始化load，token的作用是replace用户的login和password
class UserAuthenticator
  
  # 添加使用的类
  class AuthenticationError < StandardError; end

  # 加入一个read only的user attrubute，假设已经有一个用户数据，但是并没有在本app中的数据库中创建该user的信息
  attr_reader :user

  # 用来exchange已经存在的token
  def initialize(code)
    @code = code
  end

  def perform
    # 使用OctokitGEM来new一个用户
    client = Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
    # exchange出来一个token
    token = client.exchange_code_for_token(code)
    # 如果返回的obj内有error string则
    if token.try(:error).present?
      # 如果有报错则返回报错信息
      raise AuthenticationError
    else
      # 如果没有报错，则使用当前的token来创建提取用户
      user_client = Octokit::Client.new(
        access_token: token
      )
      # 提取对接的用户的内容，使用slice来提取需要的hash内容
      user_data = user_client.user.to_h.slice(:login, :avatar_url, :url, :name)
      # 判断是否已经存在user在数据库了,将值返回给@user
      @user = if User.exists?(login: user_data[:login])
        User.find_by(login: user_data[:login])
      else
        # 在本app中创建该用户，包含之前的信息，同时将probider设置为github
        User.create(user_data.merge(provider: 'github'))
      end
    end
  end

  private

  # 加入一个read only的code attrubute
  attr_reader :code

end
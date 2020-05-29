# 测试联合登陆生成token的 routes
require 'rails_helper'

describe 'access tokens routes' do
  
  # 测试login时，先调取tokens
  it 'should route to access_tokens create action' do
    expect(post '/login').to route_to('access_tokens#create')
  end

  # 登出
  it 'should route to access_tokens destory action' do
    expect(delete '/logout').to route_to('access_tokens#destroy')
  end

end
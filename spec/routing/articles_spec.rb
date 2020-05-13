# 测试article routes
require 'rails_helper'

describe 'articles routes' do
  
  # 测试articles的route是否可能显示到index的route
  it 'should route to articles index' do
    expect(get '/articles').to route_to('articles#index')
  end

  it 'should route to article 1 page' do
    expect(get '/articles/1').to route_to('articles#show', id: '1')
  end

end
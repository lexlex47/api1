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

  # 测试创建article
  it 'should royte to article create' do
    expect(post '/articles').to route_to('articles#create')
  end

  # 更新article
  it 'should route to articles update' do
    expect(put '/articles/1').to route_to('articles#update', id: '1')
    expect(patch '/articles/1').to route_to('articles#update', id: '1')
  end

end
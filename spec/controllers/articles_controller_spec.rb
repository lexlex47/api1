require 'rails_helper'

describe ArticlesController do
  # 因为有不同返回值，所以继续写一个describe
  describe '#index' do
    
    # 测试路由是否可以工作正常，返回httpcode OK
    it 'should return success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    # 测试返回的json
    it 'should return proper json data' do
      # 使用create_list方法来创建2个article obj
      FactoryBot.create_list :article, 2
      get :index
      json = JSON.parse(response.body)
      # 从server返回的data不是symbol，是string
      json_data = json['data']
      # 认为应该返回的是2个article
      expect(json_data.length).to eq(2)
      # 分别测试每个返回的json内容应该是
      expect(json_data[0]['attributes']).to eq({
        "title" => "MyString 1",
        "content" => "MyText 1",
        "slug" => "my-slug-1"
      })
      expect(json_data[1]['attributes']).to eq({
        "title" => "MyString 2",
        "content" => "MyText 2",
        "slug" => "my-slug-2"
      })
    end

  end
end
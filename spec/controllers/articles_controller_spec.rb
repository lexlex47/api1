require 'rails_helper'

describe ArticlesController do
  # 因为有不同返回值，所以继续写一个describe
  describe '#index' do
    
    # 初始化subject
    subject { get :index }

    # 测试路由是否可以工作正常，返回httpcode OK
    it 'should return success response' do
      # 调用route
      subject
      expect(response).to have_http_status(:ok)
    end

    # 测试返回的json
    it 'should return proper json data' do
      # 使用create_list方法来创建2个article obj
      FactoryBot.create_list :article, 2
      # 调用route
      subject
      # 认为应该返回的是2个article
      expect(json_data.length).to eq(2)
      # 分别测试每个返回的json内容应该是,因为index修改了article，组类都会被自动分配到recent现在，如果需要all，则去修改controller即可
      Article.recent.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq({
          # 在这里article 会自动调用factories里面的obj的值
          "title" => article.title,
          "content" => article.content,
          "slug" => article.slug
        })
      end
    end

    # 检测返回的article是否按照创建时间进行倒序
    it 'should return articles in the proper order' do
      # 创建旧的
      old_article = create :article
      # 创建新的
      new_article = create :article
      subject
      # 判断是否先返回新创建的，后返回旧创建的
      expect(json_data.first['id']).to eq(new_article.id.to_s)
      expect(json_data.last['id']).to eq(old_article.id.to_s)
    end

    # 测试是否可以返回paginate
    it 'should paginate results' do
      # 先创建3个article
      create_list :article, 3
      # 加入路由，第几页：第二页，每页的数量：每页一个
      get :index, params: {page: 2, per_page: 1}
      # 检测第二页是否只有一篇article
      expect(json_data.length).to eq 1
      # 检测第二页的这一篇是否为列表中的第二篇
      expect(json_data.first['id']).to eq(Article.recent.second.id.to_s)
    end

  end
end
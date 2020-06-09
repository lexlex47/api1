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

  describe '#create' do
    # subjet写在外面，每一个test都会调用
    subject { post :create }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      # 再改context测试中，每一个测试之前都会调用该before
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end
    
    context 'when authorized' do

      let(:access_token) { create :access_token }
      # 设置header里面已经有可以使用的token了
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        # 定义不正确的jsondatat格式
        let(:invalid_attributes) do
          {
            data:{
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
  
        subject { post :create, params: invalid_attributes }
  
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it 'should return proper error json' do
          subject
          expect(json['errors']).to include(
            {
            "source" => { "pointer" => "/data/attributes/title" },
            "detail" => "can't be blank"
            },
            {
            "source" => { "pointer" => "/data/attributes/content" },
            "detail" => "can't be blank"
            },
            {
            "source" => { "pointer" => "/data/attributes/slug" },
            "detail" => "can't be blank"
            },
        )
        end
      end

      context 'when success request sent' do
        let(:access_token) { create :access_token }
        # 设置header里面已经有可以使用的token了
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }
        # 定义不正确的jsondatat格式
        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'Title here',
                'content' => 'Content here',
                'slug' => 'this-is-some-title'
              }
            }
          }
        end
        subject {post :create, params: valid_attributes}

        # 测试如果创建成功
        it 'should have 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should have proper json body' do
          subject
          expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
        end

        # 测试article添加
        it 'should create the article' do
          expect{ subject }.to change{ Article.count }.by(1)
        end

      end
    end
  end

  # 测试更新
  describe '#update' do

    let(:article) {create :article}
    # subjet写在外面，每一个test都会调用
    subject { patch :update, params: {id: article.id} }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      # 再改context测试中，每一个测试之前都会调用该before
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when trying to update not owned article' do
      let(:other_article) { create :article }
      subject { patch :update, params: { id: other_article.id } }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }
      it_behaves_like 'forbidden_requests' 
    end
    
    context 'when authorized' do

      let(:access_token) { create :access_token }
      # 设置header里面已经有可以使用的token了
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        # 定义不正确的jsondatat格式
        let(:invalid_attributes) do
          {
            data:{
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
  
        subject do
          patch :update, params: invalid_attributes.merge(id: article.id)
        end
  
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it 'should return proper error json' do
          subject
          # 不需要测试slag，因为创建的时候只有title和content，所以不需要更新
          expect(json['errors']).to include(
            {
            "source" => { "pointer" => "/data/attributes/title" },
            "detail" => "can't be blank"
            },
            {
            "source" => { "pointer" => "/data/attributes/content" },
            "detail" => "can't be blank"
            }
        )
        end
      end

      context 'when success request sent' do
        let(:access_token) { create :access_token }
        # 设置header里面已经有可以使用的token了
        before { request.headers['authorization'] = "Bearer #{access_token.token}" }
        # 定义不正确的jsondatat格式
        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'Title here',
                'content' => 'Content here',
                'slug' => 'this-is-some-title'
              }
            }
          }
        end

        subject do
          patch :update, params: invalid_attributes.merge(id: article.id)
        end

        # 测试如果创建成功
        it 'should have 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should have proper json body' do
          subject
          expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
        end

        # 测试article添加
        it 'should update the article' do
          subject
          expect(article.reload.title).to eq(
            valid_attributes['data']['attributes']['title']
          )
        end

      end
    end
  end

end
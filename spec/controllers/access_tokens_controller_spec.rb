require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do

    describe '#create' do

      context 'when nocode provided' do  
        # 提前定义一下返回的错误，现在仅需要判断"bad_verification_code"这一个错误即可,在这里需要该写完github_error
        let(:github_error) {
          double("Sawyer::Resource", error: "bad_verification_code")
        }
        # 如果已经有报错，则直接跳过，并且直接返回错误
        before do
          allow_any_instance_of(Octokit::Client).to receive(
            :exchange_code_for_token).and_return(github_error)
        end
        subject { post :create}
        # 使用上方shared的
        it_behaves_like "unauthorized_request"
      end

      context 'when invalid request' do  
          subject { post :create, params: { code: 'invalid_code'}}
          # 使用上方shared的
          it_behaves_like "unauthorized_request"
      end

      context 'when success request' do
        subject { post :create, params: { code: 'invalid_code'}}
        # 假设已经取回的数据
        let(:user_data) do
          {
            login: 'User 1',
            url: 'https://example.com',
            avatar_url: 'https://example.com/avatar',
            name: 'My Name'
          }
        end
        # 如果已经有报错，则直接跳过，并且直接返回错误
        before do
          allow_any_instance_of(Octokit::Client).to receive(
            # 这个validaccesstoken token是api从github得到的
            :exchange_code_for_token).and_return('validaccesstoken')
          # 提前使用user_data来创建user
          allow_any_instance_of(Octokit::Client).to receive(
            :user).and_return(user_data)
        end
        it 'should return 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should return proper json body' do
          expect{ subject }.to change{ User.count }.by(1)
          user = User.find_by(login: 'User 1')
          expect(json_data['attributes']).to eq({
            # 这个 access_token是本app数据库生成的
            'token' => user.access_token.token
          })
        end

      end

    end


    describe 'DELETE #destory' do

      subject { delete :destroy }

      context 'when no authorization header provided' do
        it_behaves_like 'forbidden_requests'
      end

      context 'when valid authorization header provided' do
        before { request.headers['authorization'] = 'Invalid token' }
        it_behaves_like 'forbidden_requests'
      end

      context 'when valid request' do
        let(:user) {create :user}
        let(:access_token) { user.create_access_token } 

        before { request.headers['authorization'] = "Bearer #{access_token.token}" }

        it 'should return 204 status code' do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'should remove the proper access token' do
          expect{ subject }.to change{ AccessToken.count }.by(-1)
        end

      end

    end

end
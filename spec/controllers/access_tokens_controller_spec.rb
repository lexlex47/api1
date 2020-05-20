require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do

    describe '#create' do

      # 可以共享
      shared_examples_for "unauthorized_request" do
          # 来自于json：api的error固定格式，因为希望error json返回任何值而不是空
          # 因为json为string所以要用 =>
          # 如果是symbool则需要使用 ：
        let(:error) do
          {
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title" => "Authentication code is invalid",
          "detail" => "You must provide valid code in order to exchange it for token."
          }
        end
            # 检测是是否返回401code
            it 'should return 401 status code' do
              subject
              expect(response).to have_http_status(401)
            end

            it 'should return proper error body' do
              subject
              expect(json['errors']).to include(error)
            end
      end

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
          :exchange_code_for_token).and_return('validaccesstoken')
        # 提前使用user_data来创建user
        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end
          it 'should return 201 status code' do
            subject
            expect(response).to have_http_status(:created)
          end

        end

    end

end
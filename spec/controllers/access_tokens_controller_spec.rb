require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do

    describe '#create' do

        context 'when invalid request' do
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
            post :create
            expect(response).to have_http_status(401)
            end

            it 'should return proper error body' do
              post :create
              expect(json['errors']).to include(error)
            end

        end

        context 'when success request' do

        end

    end

end
require 'rails_helper'

# 可以共享
shared_examples_for "unauthorized_request" do
    # 来自于json：api的error固定格式，因为希望error json返回任何值而不是空
    # 因为json为string所以要用 =>
    # 如果是symbool则需要使用 ：
  let(:authorization_error) do
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
    expect(json['errors']).to include(authorization_error)
  end
end

shared_examples_for 'forbidden_requests' do
    let(:authorization_error) do
      {
      "status" => "403",
      # 一般返回的403都会在header
      "source" => { "pointer" => "/headers/authorization" },
      "title" => "Not authorized",
      "detail" => "You have no right to access this resources."
      }
    end
    it 'should return 403 status code' do
      subject
      expect(response).to have_http_status(:forbidden)
    end

    it 'should return propper error json' do
      subject
      expect(json['errors']).to include(authorization_error)
    end
  end
require 'rails_helper'

describe UserAuthenticator do
    
  describe '#perform' do
    
    # 尝试创建一个用户，使用的token是'somenthing_here'
    let(:authenticator) { described_class.new('something_here') }
    # subject一下function
    subject { authenticator.perform }

    # context 和 describe 没有区别基本上，但是可以容易阅读
    context 'when code is incorrect' do

      # 提前定义一下返回的错误，现在仅需要判断"bad_verification_code"这一个错误即可
      let(:error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }
      # 如果已经有报错，则直接跳过，并且直接返回错误
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(error)
      end
      
      # 测试不能创建用户
      it 'should raise an error' do

        # 尝试创建一个用户，使用的token是'somenthing_here',最上方使用了let，所以在这里就不用重新复写了
        # authenticator = described_class.new('something_here')

        # 认为会返回错误
        # ()与{}区别，()内写的是变量，例如 varibale = class.function,可以写(varibale)
        # {}内写的是方法，可以写{ class.function }
        expect{ subject }.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        # 认为该用户不能在本app中创建user信息，所以为空
        expect(authenticator.user).to be_nil
      end

    end

    context 'when code is correct' do
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
      # 检测如果用户不存在的情况下是否会创建新的
      it 'should save the user when does not exist' do
        # 认为可以改变user的数量，改变的值为增加1
        expect {subject}.to change{ User.count }.by(1)
        # 假设user列表中最后一位的名字为my name
        expect(User.last.name).to eq('My Name')
      end
      # 检测已经创建好的user，不会再被创建
      it 'should reuse already registerd user' do
        # 先按照user_data来创建本app的user
        user = create :user, user_data
        # 认为用户不会被创建，所以数量不变
        expect{ subject }.not_to change{ User.count }
        # 认为user是同一个
        expect(authenticator.user).to eq(user)
      end

    end

  end
end
require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe "#validations" do
    
    # 测试user factory是否valid
    it 'should have valid user factories' do
      user = build :user
      expect(user).to be_valid
    end

    # 测试用户是否valid
    it 'should validate presence of attributes' do
      # 尝试新建login 与 provider都是空的
      user = build :user, login: nil, provider: nil
      # 不valid
      expect(user).not_to be_valid
      # 返回报错
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end

    # 测试用户的login是否唯一
    it 'should validate uniqueness of login' do
      user = create :user
      new_user = build :user, login: user.login
      expect(new_user).not_to be_valid
      new_user.login = 'new login'
      expect(new_user).to be_valid
    end

  end

end

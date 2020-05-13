# 测试文件
require 'rails_helper'

RSpec.describe Article, type: :model do
  
  describe '#validation' do
    # 如果可以成功创建article
    it 'should test that the factory is valid' do
      expect(FactoryBot.build :article).to be_valid
    end

    # 测试如果article没有填写title，是否可以正常检测
    it 'should validate the presence of the title' do
      article = FactoryBot.build :article, title: ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:title]).to include("can't be blank")
    end

    # 测试如果article没有填写content，是否可以正常检测
    it 'should validate the presence of the content' do
      # 尝试使用FactoryBot创建一个article，并且是content为空值
      article = FactoryBot.build :article, content: ''
      # 认为article应该不能被创建成功，如果没有被创建，则判断正确，返回测试通过
      expect(article).not_to be_valid
      # 报错信息
      expect(article.errors.messages[:content]).to include("can't be blank")
    end

    # 测试如果article没有填写slug，是否可以正常检测
    it 'should validate the presence of the slug' do
      article = FactoryBot.build :article, slug: ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:slug]).to include("can't be blank")
    end

    # 测试slug是不是唯一
    it 'should validate uniqueness of the slug' do
      # 使用FactoryBot创建一个article并加入数据库
      article = FactoryBot.create :article
      # 尝试使用FactoryBot创建一个article，并且是slug的值为上一个article的slug值
      invaild_article = FactoryBot.build :article, slug: article.slug
      # 认为article应该不能被创建成功，如果没有被创建，则判断正确，返回测试通过
      expect(invaild_article).not_to be_valid
    end
  end
  
end

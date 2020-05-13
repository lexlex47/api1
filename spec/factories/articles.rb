# obj模型生成文件，如果在测试文件中使用create，那么生成的对应模型里的内容就在此文件进行编辑
FactoryBot.define do
  factory :article do

    # 生成单一obj，每个obj内容都会相同
    # title { "MyString" }
    # content { "MyText" }
    # slug { "MyString" }

    # 生成多个obj，每个obj内容可以为dynamic
    sequence(:title) { |n| "MyString #{n}" }
    sequence(:content) { |n| "MyText #{n}" }
    sequence(:slug) { |n| "my-slug-#{n}" }
    
  end
end

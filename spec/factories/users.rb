FactoryBot.define do
  factory :user do
    # 先使用一些简单的静态测试data
    sequence(:login) { |n| "User #{n}" }
    name { "My Name" }
    url { "https://example.com" }
    avatar_url { "https://example.com/avatar" }
    provider { "github" }
  end
end

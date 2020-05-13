class Article < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :slug, presence: true, uniqueness: true

    # 使用scope，创建一组recent分类，排序方法为使用倒序的创建时间
    scope :recent, -> { order(created_at: :desc)}
end

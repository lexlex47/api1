# 模型的obj的json，在这里显示的json都可以被client访问到
class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :slug
end

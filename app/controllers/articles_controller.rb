class ArticlesController < ApplicationController

  def index
    # 获取article中的recent分类
    articles = Article.recent
    # 需要传入空的json，要么route test不会返回正确的http值
    render json: articles
  end

  def show

  end

end
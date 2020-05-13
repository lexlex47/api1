class ArticlesController < ApplicationController

  def index
    articles = Article.all
    # 需要传入空的json，要么route test不会返回正确的http值
    render json: articles
  end

  def show

  end

end
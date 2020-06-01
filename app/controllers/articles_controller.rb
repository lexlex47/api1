class ArticlesController < ApplicationController

  skip_before_action :authorize!, only: [:index, :show]

  def index
    # 获取article中的recent分类
    articles = Article.recent.
      # 加入paganation后
      page(params[:page]).per(params[:per_page])
    # 需要传入空的json，要么route test不会返回正确的http值
    render json: articles
  end

  def show
    render json: Article.find(params[:id])
  end

  def create
    article = Article.new(article_params)
    article.save
    render json: article, status: :created
    rescue
      render json: article, adapter: :json_api,
                            serializer: ErrorSerializer,
                            status: :unprocessable_entity
  end

  private

  def article_params
    params.require(:data).require(:attributes).permit(:title, :content, :slug) ||
    ActionController::Parameters.new
  end

end
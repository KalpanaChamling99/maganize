class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.published.recent.includes(:category, :tags)
  end

  def show
    @related_articles = Article.published.recent
      .where(category: @article.category)
      .where.not(id: @article.id)
      .includes(:category, :tags)
      .limit(3)
  end

  private

  def set_article
    @article = Article.includes(:category, :tags).find(params[:id])
  end
end

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.published.recent.includes(:category, :tags, :author)
  end

  def show
    @related_articles = Article.published.recent
      .where(category: @article.category)
      .where.not(id: @article.id)
      .includes(:category, :tags, :author)
      .limit(3)
  end

  private

  def set_article
    @article = Article.includes(:category, :tags, :author).find(params[:id])
  end
end

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.published.recent.includes(:category, :tags)
  end

  def show
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end
end

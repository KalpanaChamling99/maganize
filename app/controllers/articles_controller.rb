class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    per = [6, 12, 24].include?(params[:per_page].to_i) ? params[:per_page].to_i : 12
    @categories = Category.joins(:articles).merge(Article.published).distinct.order(:name)
    @current_category = Category.find_by(id: params[:category_id]) if params[:category_id].present?
    scope = Article.published.recent.includes(:categories, :tags, :author)
    scope = scope.joins(:categories).where(categories: { id: @current_category.id }) if @current_category
    if params[:year].present? && params[:month].present?
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      scope = scope.where(published_at: @current_date.beginning_of_month..@current_date.end_of_month)
    end
    @articles = scope.distinct.page(params[:page]).per(per)
  end

  def show
    @related_articles = Article.published.recent
      .joins(:categories)
      .where(categories: { id: @article.category_ids })
      .where.not(id: @article.id)
      .includes(:categories, :tags, :author)
      .distinct
      .limit(3)
  end

  private

  def set_article
    @article = Article.includes(:categories, :tags, :author).find(params[:id])
  end
end

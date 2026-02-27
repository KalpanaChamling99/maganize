class HomeController < ApplicationController
  def index
    @featured_articles = Article.published.featured.recent.includes(:categories, :tags, :author).limit(3)
    @recent_articles = Article.published.recent.includes(:categories, :tags, :author).limit(9)
    @categories = Category.all
    @featured_collections = Collection.featured.with_attached_cover_image.includes(articles: [:categories, :tags, :author])
  end
end

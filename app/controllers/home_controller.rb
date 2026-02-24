class HomeController < ApplicationController
  def index
    @featured_articles = Article.published.featured.recent.includes(:category, :tags, :author).limit(3)
    @recent_articles = Article.published.recent.includes(:category, :tags, :author).limit(9)
    @categories = Category.all
    @featured_collections = Collection.featured.includes(articles: [:category, :tags, :author])
  end
end

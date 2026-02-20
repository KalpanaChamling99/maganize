class HomeController < ApplicationController
  def index
    @featured_articles = Article.published.featured.recent.limit(3)
    @recent_articles = Article.published.recent.limit(9)
    @categories = Category.all
  end
end

class Admin::DashboardController < Admin::BaseController
  def index
    @total_articles   = Article.count
    @published_count  = Article.published.count
    @draft_count      = @total_articles - @published_count
    @featured_count   = Article.featured.count
    @total_categories = Category.count
    @total_tags       = Tag.count
    @recent_articles  = Article.order(created_at: :desc).limit(8)
  end
end

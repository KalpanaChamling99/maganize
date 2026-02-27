class BookmarksController < ApplicationController
  PER_PAGE = 6

  def index
    return unless params[:ids].present?

    per  = [6, 12, 24].include?(params[:per_page].to_i) ? params[:per_page].to_i : PER_PAGE
    ids  = params[:ids].to_s.split(',').map(&:to_i).uniq.first(100)
    @articles = Article.published
                       .where(id: ids)
                       .includes(:author, :categories, :tags)
                       .with_attached_images
                       .page(params[:page]).per(per)
  end
end

class TagsController < ApplicationController
  def index
    @tags = Tag.all.sort_by { |t| -t.articles.count }
  end

  def show
    @tag = Tag.find_by!(slug: params[:id])
    @articles = @tag.articles.published.recent.includes(:categories, :tags, :author)
  end

end

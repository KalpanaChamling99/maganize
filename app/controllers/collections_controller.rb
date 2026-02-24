class CollectionsController < ApplicationController
  def index
    @collections = Collection.includes(:articles).order(created_at: :desc)
  end

  def show
    @collection = Collection.find(params[:id])
    @articles = @collection.articles.includes(:category, :tags, :author)
  end
end

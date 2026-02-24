class Admin::CollectionsController < Admin::BaseController
  before_action :set_collection, only: [:edit, :update, :destroy]
  before_action -> { require_permission(:manage_collections) }, only: [:new, :create, :edit, :update, :destroy]

  def index
    @collections = Collection.includes(:articles).order(created_at: :desc)
  end

  def new
    @collection = Collection.new
    @articles = Article.published.recent.includes(:category)
  end

  def create
    @collection = Collection.new(collection_params)
    if @collection.save
      redirect_to admin_collections_path, notice: "Collection created."
    else
      @articles = Article.published.recent.includes(:category)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @articles = Article.published.recent.includes(:category)
  end

  def update
    if @collection.update(collection_params)
      redirect_to admin_collections_path, notice: "Collection updated."
    else
      @articles = Article.published.recent.includes(:category)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy
    redirect_to admin_collections_path, notice: "Collection deleted."
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title, article_ids: [])
  end
end

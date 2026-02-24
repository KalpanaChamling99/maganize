class Admin::CollectionsController < Admin::BaseController
  before_action :set_collection, only: [:edit, :update, :destroy, :purge_cover]
  before_action -> { require_permission(:manage_collections) }, only: [:new, :create, :edit, :update, :destroy, :purge_cover]

  def index
    @collections = Collection.includes(:articles).with_attached_cover_image.order(created_at: :desc)
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
    redirect_to admin_collections_path, status: :see_other, notice: "Collection deleted."
  end

  def purge_cover
    @collection.cover_image.purge
    redirect_to edit_admin_collection_path(@collection), notice: "Cover image removed."
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title, :featured, :cover_image, article_ids: [])
  end
end

class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :purge_image]
  before_action :set_form_data, only: [:new, :edit]

  def index
    @articles = Article.includes(:category, :tags).order(created_at: :desc)
  end

  def show
    redirect_to edit_admin_article_path(@article)
  end

  def new
    @article = Article.new(published_at: Time.current)
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.tag_ids = tag_ids_from_params

    if @article.save
      redirect_to admin_articles_path, notice: "Article \"#{@article.title}\" was created."
    else
      set_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article.tag_ids = tag_ids_from_params

    if @article.update(article_params)
      redirect_to admin_articles_path, notice: "Article updated."
    else
      set_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    title = @article.title
    @article.destroy!
    redirect_to admin_articles_path, notice: "\"#{title}\" was deleted."
  end

  def purge_image
    @article.images.attachments.find(params[:image_id]).purge
    redirect_to edit_admin_article_path(@article), notice: "Image removed."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def set_form_data
    @categories = Category.all
    @tags = Tag.all
  end

  def tag_ids_from_params
    Array(params.dig(:article, :tag_ids)).reject(&:blank?).map(&:to_i)
  end

  def article_params
    params.require(:article).permit(:title, :excerpt, :body, :published_at, :featured, :cover_image, :category_id, images: [])
  end
end

class Admin::ArticlesController < Admin::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :purge_image]
  before_action :set_form_data, only: [:new, :edit]
  before_action -> { require_permission(:create_articles) }, only: [:new, :create]
  before_action -> { require_permission(:edit_articles) },   only: [:edit, :update, :purge_image]
  before_action -> { require_permission(:delete_articles) }, only: [:destroy]

  SORT_MAP = {
    "title"    => { col: "articles.title",        join: nil },
    "author"   => { col: "team_members.name",     join: :author },
    "category" => { col: "categories.name",       join: :categories },
    "status"   => { col: "articles.published_at", join: nil },
    "date"     => { col: "articles.created_at",   join: nil },
  }.freeze

  def index
    per        = [10, 20, 50, 100].include?(params[:per_page].to_i) ? params[:per_page].to_i : 10
    @sort      = SORT_MAP.key?(params[:sort]) ? params[:sort] : "date"
    @direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    cfg   = SORT_MAP[@sort]
    scope = Article.includes(:categories, :tags, :author).with_attached_images
    scope = scope.left_joins(cfg[:join]) if cfg[:join]

    @articles = scope.order(Arel.sql("#{cfg[:col]} #{@direction} NULLS LAST"))
                     .distinct
                     .page(params[:page]).per(per)
  end

  def show
    redirect_to edit_admin_article_path(@article)
  end

  def new
    @article = Article.new(
      published_at: Time.current,
      team_member_id: current_admin_user.team_member_id
    )
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.team_member_id = current_admin_user.team_member_id unless root_admin?
    @article.tag_ids      = tag_ids_from_params
    @article.category_ids = category_ids_from_params

    if @article.save
      attach_gallery_images
      redirect_to admin_articles_path, notice: "Article \"#{@article.title}\" was created."
    else
      set_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article.tag_ids      = tag_ids_from_params
    @article.category_ids = category_ids_from_params

    if @article.update(article_params)
      attach_gallery_images
      replace_gallery_images
      redirect_to edit_admin_article_path(@article), notice: "Article updated."
    else
      set_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    title = @article.title
    @article.destroy!
    redirect_to admin_articles_path, status: :see_other, notice: "\"#{title}\" was deleted."
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
    @categories = Category.order(:name)
    @tags = Tag.all
  end

  def tag_ids_from_params
    Array(params.dig(:article, :tag_ids)).reject(&:blank?).map(&:to_i)
  end

  def category_ids_from_params
    Array(params.dig(:article, :category_ids)).reject(&:blank?).map(&:to_i)
  end

  def attach_gallery_images
    raw = params.dig(:article, :images)
    return if raw.blank?
    Array(raw).each do |file|
      next unless file.respond_to?(:read) && file.original_filename.present?
      @article.images.attach(file)
    end
  end

  def replace_gallery_images
    replacements = params.dig(:article, :replace_image)
    return if replacements.blank?
    replacements.each do |attachment_id, file|
      next unless file.respond_to?(:read) && file.original_filename.present?
      attachment = @article.images.attachments.find_by(id: attachment_id.to_i)
      next unless attachment
      attachment.purge
      @article.images.attach(file)
    end
  end

  def article_params
    permitted = [:title, :excerpt, :body, :published_at, :featured]
    permitted << :team_member_id if root_admin?
    params.require(:article).permit(*permitted)
  end

  def root_admin?
    current_admin_user.role&.name == "Root Admin"
  end
end

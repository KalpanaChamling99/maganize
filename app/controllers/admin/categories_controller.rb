class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    per = [10, 20, 50, 100].include?(params[:per_page].to_i) ? params[:per_page].to_i : 10
    @categories = Category.order(:name).page(params[:page]).per(per)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category \"#{@category.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @category.name
    @category.destroy!
    redirect_to admin_categories_path, notice: "\"#{name}\" was deleted."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug, :description)
  end
end

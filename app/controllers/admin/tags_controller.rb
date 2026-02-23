class Admin::TagsController < Admin::BaseController
  def index
    @tags = Tag.left_joins(:article_tags)
               .group(:id)
               .order("COUNT(article_tags.tag_id) DESC")
               .page(params[:page]).per(10)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: "Tag \"#{@tag.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    name = @tag.name
    @tag.destroy!
    redirect_to admin_tags_path, notice: "Tag \"#{name}\" was deleted."
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end

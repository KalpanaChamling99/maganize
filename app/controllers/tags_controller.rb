class TagsController < ApplicationController
  def index
    @tags = Tag.all.sort_by { |t| -t.articles.count }
  end

  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.articles.published.recent.includes(:category, :tags, :author)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path, notice: "Tag \"#{@tag.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end

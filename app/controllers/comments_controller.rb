class CommentsController < ApplicationController
  before_action :require_viewer, only: [:create]
  before_action :set_comment,    only: [:edit, :update]
  before_action :require_owner,  only: [:edit, :update]

  def create
    @article = Article.published.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.name  = current_user.name
    @comment.email = current_user.email
    @comment.user  = current_user

    if @comment.save
      redirect_to article_path(@article, anchor: "comment-#{@comment.id}"),
        notice: "Your comment was posted successfully."
    else
      redirect_to article_path(@article, anchor: "comment-form"),
        alert: @comment.errors.full_messages.to_sentence
    end
  end

  def edit
    @article = @comment.article
  end

  def update
    if @comment.update(comment_params)
      redirect_to article_path(@comment.article, anchor: "comment-#{@comment.id}"),
        notice: "Comment updated."
    else
      @article = @comment.article
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def require_owner
    owned = @comment.user_id == current_user&.id ||
            (@comment.user_id.nil? && @comment.email == current_user&.email)
    unless owned
      redirect_back fallback_location: root_path, alert: "Not authorized."
    end
  end

  def require_viewer
    unless current_user&.role == "viewer"
      redirect_to article_path(params[:article_id], anchor: "comments"),
        alert: "You must be signed in as a viewer to post a comment."
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

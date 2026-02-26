class CommentsController < ApplicationController
  before_action :require_admin_login

  def create
    @article = Article.published.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.name  = current_admin_user.name
    @comment.email = current_admin_user.email

    if @comment.save
      redirect_to article_path(@article, anchor: "comments"),
        notice: "Your comment was posted successfully."
    else
      redirect_to article_path(@article, anchor: "comment-form"),
        alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def require_admin_login
    unless current_admin_user
      redirect_to article_path(params[:article_id], anchor: "comments"),
        alert: "You must be signed in to post a comment."
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

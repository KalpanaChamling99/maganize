class ArticleRatingsController < ApplicationController
  def create
    article = Article.published.find(params[:article_id])
    value   = params[:value].to_i

    if current_user
      rating = article.ratings.find_or_initialize_by(user: current_user)
      rating.value = value
      if rating.save
        redirect_to article_path(article, anchor: "rating"), notice: "Thanks for rating!"
      else
        redirect_to article_path(article, anchor: "rating"), alert: rating.errors.full_messages.to_sentence
      end
    else
      session_key = "rating_article_#{article.id}"
      existing_id = session[session_key]
      rating = existing_id ? article.ratings.find_by(id: existing_id) : nil
      rating ||= article.ratings.build

      rating.value = value
      if rating.save
        session[session_key] = rating.id
        redirect_to article_path(article, anchor: "rating"), notice: "Thanks for rating!"
      else
        redirect_to article_path(article, anchor: "rating"), alert: rating.errors.full_messages.to_sentence
      end
    end
  end
end

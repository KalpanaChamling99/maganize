class CommentReactionsController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    article = comment.article
    emoji   = params[:emoji]

    if current_user
      existing = comment.reactions.find_by(user: current_user)
      if existing&.emoji == emoji
        # Same emoji — toggle off
        existing.destroy
      else
        # Different emoji or no reaction — replace
        existing&.destroy
        comment.reactions.create!(user: current_user, emoji: emoji)
      end
    else
      # Guest: find any existing reaction for this session on this comment
      existing_key = CommentReaction::ALL_EMOJIS.map { |e| "reaction_#{comment.id}_#{e}" }
                                            .find { |k| session[k].present? }
      if existing_key
        comment.reactions.find_by(id: session[existing_key])&.destroy
        session.delete(existing_key)
      end

      new_key = "reaction_#{comment.id}_#{emoji}"
      # Only add if we didn't just remove the same emoji
      unless existing_key == new_key
        reaction = comment.reactions.create!(emoji: emoji)
        session[new_key] = reaction.id
      end
    end

    redirect_to article_path(article, anchor: "comment-#{comment.id}")
  end
end

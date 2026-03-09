class CommentReaction < ApplicationRecord
  EMOJIS    = %w[👍 ❤️ 😄 🔥].freeze
  DISLIKE   = "👎"
  ALL_EMOJIS = (EMOJIS + [DISLIKE]).freeze

  belongs_to :comment
  belongs_to :user, optional: true

  validates :emoji, presence: true, inclusion: { in: ALL_EMOJIS }
  validates :user_id, uniqueness: { scope: :comment_id, allow_nil: true }
end

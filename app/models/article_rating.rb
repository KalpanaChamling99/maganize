class ArticleRating < ApplicationRecord
  belongs_to :article
  belongs_to :user, optional: true

  validates :value, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :article_id, allow_nil: true }
end

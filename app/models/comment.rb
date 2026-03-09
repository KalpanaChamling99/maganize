class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user, optional: true
  has_many :reactions, class_name: "CommentReaction", dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end

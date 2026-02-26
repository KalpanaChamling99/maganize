class Article < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :author, class_name: "TeamMember", foreign_key: :team_member_id, optional: true
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_many :collection_articles, dependent: :destroy
  has_many :collections, through: :collection_articles
  has_many :comments, dependent: :destroy

  has_rich_text :body
  has_many_attached :images

  validates :title, presence: true
  validates :published_at, presence: true

  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(published_at: :desc) }

  def published?
    published_at.present? && published_at <= Time.current
  end
end

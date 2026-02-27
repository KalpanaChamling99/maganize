class Category < ApplicationRecord
  AUTO_COLORS = %w[
    #ef4444 #3b82f6 #16a34a #9333ea #f59e0b #ec4899
    #6366f1 #14b8a6 #f97316 #06b6d4 #f43f5e #7c3aed
  ].freeze

  has_many :article_categories, dependent: :destroy
  has_many :articles, through: :article_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save :generate_slug
  before_save :ensure_color

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end

  def ensure_color
    return if color.present?
    seed = name.to_s.bytes.sum
    self.color = AUTO_COLORS[seed % AUTO_COLORS.length]
  end
end

class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags

  before_save :generate_slug

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end
end

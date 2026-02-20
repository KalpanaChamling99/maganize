class Category < ApplicationRecord
  has_many :articles, dependent: :destroy

  before_save :generate_slug

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end
end

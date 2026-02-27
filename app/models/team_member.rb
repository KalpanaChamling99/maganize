class TeamMember < ApplicationRecord
  has_one_attached :avatar
  has_many :articles, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "is already taken by another team member" }
  validates :role, presence: true

  before_save :generate_slug

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end
end

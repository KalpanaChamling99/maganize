class Collection < ApplicationRecord
  has_many :collection_articles, dependent: :destroy
  has_many :articles, through: :collection_articles

  has_one_attached :cover_image

  validates :title, presence: true

  scope :featured, -> { where(featured: true) }
end

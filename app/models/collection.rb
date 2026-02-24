class Collection < ApplicationRecord
  has_many :collection_articles, dependent: :destroy
  has_many :articles, through: :collection_articles

  validates :title, presence: true
end

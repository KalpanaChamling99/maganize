class CollectionArticle < ApplicationRecord
  belongs_to :collection
  belongs_to :article
end

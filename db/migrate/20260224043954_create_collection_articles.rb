class CreateCollectionArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_articles do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end

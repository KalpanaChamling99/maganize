class CreateArticleRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :article_ratings do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
    add_index :article_ratings, [:article_id, :user_id], unique: true
  end
end

class CreateArticleCategories < ActiveRecord::Migration[7.1]
  def up
    create_table :article_categories do |t|
      t.references :article,  null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :article_categories, [:article_id, :category_id], unique: true

    # Migrate existing single category_id into the join table
    execute <<~SQL
      INSERT INTO article_categories (article_id, category_id, created_at, updated_at)
      SELECT id, category_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM articles
      WHERE category_id IS NOT NULL
    SQL

    remove_column :articles, :category_id
  end

  def down
    add_column :articles, :category_id, :integer
    add_index :articles, :category_id

    execute <<~SQL
      UPDATE articles
      SET category_id = (
        SELECT category_id
        FROM article_categories
        WHERE article_categories.article_id = articles.id
        LIMIT 1
      )
    SQL

    drop_table :article_categories
  end
end

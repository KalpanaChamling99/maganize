class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :excerpt
      t.text :body
      t.datetime :published_at
      t.boolean :featured
      t.string :cover_image
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end

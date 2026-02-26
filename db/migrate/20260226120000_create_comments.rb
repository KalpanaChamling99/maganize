class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :article, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.text   :body, null: false

      t.timestamps
    end

    add_index :comments, :created_at
  end
end

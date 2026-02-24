class AddFeaturedToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :featured, :boolean, default: false, null: false
  end
end

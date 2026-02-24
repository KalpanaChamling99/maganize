class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :title

      t.timestamps
    end
  end
end

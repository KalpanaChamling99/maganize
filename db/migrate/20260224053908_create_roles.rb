class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name,        null: false
      t.text   :permissions, null: false, default: "--- []\n"

      t.timestamps
    end
    add_index :roles, :name, unique: true
  end
end

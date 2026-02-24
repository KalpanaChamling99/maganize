class AddRoleToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :role, :integer, null: false, default: 3
  end
end

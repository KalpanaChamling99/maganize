class AddRoleIdRemoveRoleFromAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column    :admin_users, :role_id, :integer
    add_index     :admin_users, :role_id
    remove_column :admin_users, :role, :integer
  end
end

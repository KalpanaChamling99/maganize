class AddUniqueIndexOneReactionPerUserPerComment < ActiveRecord::Migration[7.1]
  def change
    remove_index :comment_reactions, [:comment_id, :user_id, :emoji], if_exists: true
    add_index :comment_reactions, [:comment_id, :user_id], unique: true, where: "user_id IS NOT NULL"
  end
end

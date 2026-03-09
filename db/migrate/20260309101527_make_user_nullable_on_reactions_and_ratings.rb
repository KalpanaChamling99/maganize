class MakeUserNullableOnReactionsAndRatings < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comment_reactions, :user_id, true
    change_column_null :article_ratings,   :user_id, true
  end
end

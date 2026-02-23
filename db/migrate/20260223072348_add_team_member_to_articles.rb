class AddTeamMemberToArticles < ActiveRecord::Migration[7.1]
  def change
    add_reference :articles, :team_member, null: true, foreign_key: true
  end
end

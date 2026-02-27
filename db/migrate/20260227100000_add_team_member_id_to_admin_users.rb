# frozen_string_literal: true

class AddTeamMemberIdToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :admin_users, :team_member, null: true, foreign_key: true
  end
end

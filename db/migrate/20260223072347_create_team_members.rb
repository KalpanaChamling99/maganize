class CreateTeamMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :team_members do |t|
      t.string :name
      t.string :role
      t.text :bio
      t.string :slug

      t.timestamps
    end
  end
end

class AddReftoTeams < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :teams, :users, column: :owner_id
    add_foreign_key :users, :teams, column: :owned_teams_id
  end
end

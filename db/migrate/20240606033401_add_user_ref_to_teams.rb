class AddUserRefToTeams < ActiveRecord::Migration[7.1]
  def change
    add_reference :teams, :owner
    add_reference :users, :owned_teams
  end
end

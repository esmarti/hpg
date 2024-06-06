class AddTeamRefToCredentials < ActiveRecord::Migration[7.1]
  def change
    add_reference :credentials, :team, foreign_key: true
  end
end

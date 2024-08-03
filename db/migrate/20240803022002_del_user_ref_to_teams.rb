class DelUserRefToTeams < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :teams, :users, column: :owner_id
    #add_reference :teams, :owner, null: false, foreign_key: { to_table: :users }
  end
end

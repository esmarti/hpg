class DelOwnerFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_reference :teams, :owner, foreign_key: { to_table: :users }, index: true
    remove_reference :users, :owned_teams, index: true
  end
end

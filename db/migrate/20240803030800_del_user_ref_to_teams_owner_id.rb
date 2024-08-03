class DelUserRefToTeamsOwnerId < ActiveRecord::Migration[7.1]
  def change
    remove_reference :teams, :owner
  end
end

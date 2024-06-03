class DelRefToUser < ActiveRecord::Migration[7.1]
  def change
    remove_reference :users, :owner
    remove_reference :users, :encrypted_for
  end
end

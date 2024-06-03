class AddRefToCredentials < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :credentials, :users, column: :owner_id, primary_key: :id
    add_foreign_key :credentials, :users, column: :encrypted_for_id, primary_key: :id
  end
end

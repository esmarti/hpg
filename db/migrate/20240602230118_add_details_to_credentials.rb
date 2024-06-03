class AddDetailsToCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :credentials, :username, :string
    add_column :credentials, :pass, :string
    add_column :credentials, :description, :text
    add_reference :credentials, :owner
    add_reference :credentials, :encrypted_for
  end
end

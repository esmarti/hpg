class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :lastname, :string
    add_column :users, :email, :string
    add_index :users, :email
    add_column :users, :role, :integer, :default => 0
  end
end

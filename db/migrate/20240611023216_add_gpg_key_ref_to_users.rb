class AddGpgKeyRefToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :gpg_key, foreign_key: true
  end
end

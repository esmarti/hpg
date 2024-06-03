class AddRefToCredential < ActiveRecord::Migration[7.1]
  def change
    add_reference :credentials, :owner
    add_reference :credentials, :encrypted_for
  end
end

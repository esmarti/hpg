class CreateGpgKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :gpg_keys do |t|
      t.text :description
      t.text :gpg_public_key

      t.timestamps
    end
  end
end

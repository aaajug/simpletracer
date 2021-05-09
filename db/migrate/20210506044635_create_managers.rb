class CreateManagers < ActiveRecord::Migration[6.1]
  def change
    create_table :managers do |t|
      t.string :managerId
      t.string :password
      t.string :addedBy

      t.timestamps
    end
  end
end

class CreateEstablishments < ActiveRecord::Migration[6.1]
  def change
    create_table :establishments do |t|
      t.string :estname
      t.string :password

      t.timestamps
    end

    # add_index :establishments, :estname, unique: true
  end
end

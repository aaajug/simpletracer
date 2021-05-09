class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.string :fullname
      t.string :email
      t.string :mobile
      t.integer :establishmentId

      t.timestamps
    end
  end
end

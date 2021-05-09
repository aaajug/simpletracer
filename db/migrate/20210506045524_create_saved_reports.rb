class CreateSavedReports < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_reports do |t|
      t.string :email
      t.string :name
      t.string :caseDate
      t.string :linkToFile

      t.timestamps
    end
  end
end

# class LogsPk < ActiveRecord::Migration[6.1]
#   def change
#     execute 'ALTER TABLE logs DROP PRIMARY KEY'
#     execute "ALTER TABLE words ADD PRIMARY KEY (email,establishmentid,created_at);"

#     # add_index :log_index, ["email","establishmentid","created_at"], :unique => true
#   end
# end
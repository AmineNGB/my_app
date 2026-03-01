class RemoveEmailAddUsernameToUsers < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, :email
    remove_column :users, :email, :string

    add_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end
end

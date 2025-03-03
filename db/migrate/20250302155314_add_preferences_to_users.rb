class AddPreferencesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :relation_type, :integer, null: false, default: 0  # 0: family, 1: by_marriage
    add_column :users, :only_same_gender, :boolean, default: false
  end
end

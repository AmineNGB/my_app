class CreateExclusions < ActiveRecord::Migration[7.2]
  def change
    create_table :exclusions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :excluded_user, null: false, foreign_key: { to_table: :users } # ✅ Corrigé ici !

      t.timestamps
    end
    add_index :exclusions, [ :user_id, :excluded_user_id ], unique: true
  end
end

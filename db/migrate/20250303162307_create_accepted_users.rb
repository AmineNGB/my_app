class CreateAcceptedUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :accepted_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :accepted_user, null: false, foreign_key: { to_table: :users } # ✅ Corrigé ici !

      t.timestamps
    end
  end
end

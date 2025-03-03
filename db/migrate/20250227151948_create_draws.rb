class CreateDraws < ActiveRecord::Migration[7.0]
  def change
    create_table :draws do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: { to_table: :users }  # ✅ Important !
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end

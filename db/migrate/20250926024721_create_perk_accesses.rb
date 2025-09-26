class CreatePerkAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :perk_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :perk, null: false, foreign_key: true

      t.timestamps
    end

    add_index :perk_accesses, [:user_id, :perk_id], unique: true
  end
end

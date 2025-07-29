class CreateTiers < ActiveRecord::Migration[8.0]
  def change
    create_table :tiers do |t|
      t.string :tier_name, null: false
      t.string :stripe_price_id, null: false
      t.decimal :monthly_credit, null: false, precision: 10, scale: 2
      t.decimal :monthly_tier_price, null: false, precision: 10, scale: 2
      t.decimal :yearly_tier_price, null: false, precision: 10, scale: 2
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :tiers, :tier_name, unique: true
    add_index :tiers, :stripe_price_id, unique: true
  end
end

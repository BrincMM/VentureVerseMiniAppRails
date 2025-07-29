class CreateCreditSpents < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_spents do |t|
      t.datetime :timestamp, null: false
      t.references :user, null: false, foreign_key: true
      t.decimal :credit_spent, null: false, precision: 10, scale: 2
      t.integer :spend_type, null: false

      t.timestamps
    end

    add_index :credit_spents, :timestamp
    add_index :credit_spents, [:user_id, :timestamp]
  end
end

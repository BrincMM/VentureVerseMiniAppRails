class CreateCreditTopups < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_topups do |t|
      t.datetime :timestamp, null: false
      t.references :user, null: false, foreign_key: true
      t.decimal :credit_topup, null: false, precision: 10, scale: 2

      t.timestamps
    end

    add_index :credit_topups, :timestamp
    add_index :credit_topups, [:user_id, :timestamp]
  end
end

class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.references :app, null: false, foreign_key: true
      t.string :api_key, null: false
      t.integer :rate_limit_per_minute, default: 100
      t.integer :rate_limit_per_day, default: 10000
      t.integer :status, default: 0, null: false
      t.datetime :expires_at
      t.datetime :last_used_at

      t.timestamps
    end

    add_index :api_keys, :api_key, unique: true
    add_index :api_keys, :status
  end
end

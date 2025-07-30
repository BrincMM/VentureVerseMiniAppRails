class CreateLogInHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :log_in_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :timestamp, null: false
      t.text :metadata

      t.timestamps
    end

    add_index :log_in_histories, :timestamp
    add_index :log_in_histories, [:user_id, :timestamp]
  end
end

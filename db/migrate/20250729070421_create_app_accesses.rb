class CreateAppAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :app_accesses do |t|
      t.references :app, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :app_accesses, [:user_id, :app_id], unique: true
  end
end

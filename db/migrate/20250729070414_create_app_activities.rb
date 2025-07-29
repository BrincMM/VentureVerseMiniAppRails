class CreateAppActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :app_activities do |t|
      t.integer :activity_type, null: false
      t.string :app_meta
      t.references :app, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :timestamp, null: false

      t.timestamps
    end

    add_index :app_activities, [:app_id, :timestamp]
    add_index :app_activities, [:user_id, :timestamp]
    add_index :app_activities, :timestamp
  end
end

class UpdateAppsTable < ActiveRecord::Migration[8.0]
  def change
    # Rename link column to app_url
    rename_column :apps, :link, :app_url

    # Add new columns
    add_column :apps, :developer_id, :integer
    add_column :apps, :status, :integer
    add_column :apps, :rate_limit_max_requests, :integer
    add_column :apps, :rate_limit_window_ms, :integer

    # Add index for developer_id (no foreign key constraint as developer table doesn't exist yet)
    add_index :apps, :developer_id
  end
end

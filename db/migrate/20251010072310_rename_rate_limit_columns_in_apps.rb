class RenameRateLimitColumnsInApps < ActiveRecord::Migration[8.0]
  def change
    rename_column :apps, :rate_limit_max_requests, :rate_limit_requests_per_day
    rename_column :apps, :rate_limit_window_ms, :rate_limit_requests_per_minute
  end
end

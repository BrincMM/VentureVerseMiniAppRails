class RemoveRateLimitColumnsFromApps < ActiveRecord::Migration[8.0]
  def change
    remove_column :apps, :rate_limit_requests_per_day, :integer
    remove_column :apps, :rate_limit_requests_per_minute, :integer
  end
end

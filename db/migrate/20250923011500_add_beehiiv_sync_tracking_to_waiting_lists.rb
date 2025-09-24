class AddBeehiivSyncTrackingToWaitingLists < ActiveRecord::Migration[8.0]
  def change
    add_column :waiting_lists, :beehiiv_synced_at, :datetime
    add_column :waiting_lists, :beehiiv_sync_is_success, :boolean
    add_column :waiting_lists, :beehiiv_sync_error, :text
    add_column :waiting_lists, :beehiiv_subscriber_id, :string
  end
end



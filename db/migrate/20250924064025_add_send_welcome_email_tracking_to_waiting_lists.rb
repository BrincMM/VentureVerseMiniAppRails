class AddSendWelcomeEmailTrackingToWaitingLists < ActiveRecord::Migration[8.0]
  def change
    add_column :waiting_lists, :send_welcome_email_is_success, :boolean
    add_column :waiting_lists, :send_welcome_email_at, :datetime
  end
end

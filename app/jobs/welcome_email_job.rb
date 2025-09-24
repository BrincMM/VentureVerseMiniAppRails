class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(waiting_list_id)
    waiting_list = WaitingList.find_by(id: waiting_list_id)
    return unless waiting_list

    begin
      UserMailer.with(email: waiting_list.email).waiting_list_welcome_email.deliver_now
      update_welcome_email_status(waiting_list, true)
    rescue => e
      Rails.logger.error("Failed to deliver welcome email for WaitingList##{waiting_list_id}: #{e.message}")
      update_welcome_email_status(waiting_list, false)
    end
  end

  private

  def update_welcome_email_status(waiting_list, success)
    waiting_list.update(
      send_welcome_email_is_success: success,
      send_welcome_email_at: Time.current
    )
  rescue => e
    Rails.logger.error("Failed to update welcome email status for WaitingList##{waiting_list.id}: #{e.message}")
  end
end

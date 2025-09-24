class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(email)
    UserMailer.with(email: email).waiting_list_welcome_email.deliver_now
  end
end

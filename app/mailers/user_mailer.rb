class UserMailer < ApplicationMailer
  def forgot_password_email
    @email = params[:email]
    @code = params[:code]
    
    mail(
      to: @email,
      subject: "Reset Your Password - VentureVerse"
    )
  end

  def waiting_list_welcome_email
    @email = params[:email]
    
    mail(
      to: @email,
      subject: "🎉 You're on the list!"
    )
  end
end
class DeveloperMailer < ApplicationMailer
  def forgot_password_email
    @email = params[:email]
    @code = params[:code]
    
    mail(
      to: @email,
      subject: "Reset Your Password - VentureVerse Developer"
    )
  end
end


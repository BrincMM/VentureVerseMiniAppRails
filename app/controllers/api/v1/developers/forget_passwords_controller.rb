module Api
  module V1
    module Developers
      class ForgetPasswordsController < ApiController
        def create
          if params[:email].blank?
            render 'api/v1/shared/error', 
              locals: { 
                message: 'Failed to create verification code', 
                errors: ['Email is required'] 
              }, 
              status: :unprocessable_entity, 
              formats: [:json]
            return
          end

          @developer = Developer.find_by(email: params[:email])
          
          if @developer
            # Generate a random 6-digit code
            code = rand(100000..999999)
            
            # Create forget password record
            forget_password = ForgetPassword.new(
              email: @developer.email,
              code: code
            )
            
            if forget_password.save
              # Send verification code email to developer
              DeveloperMailer.with(email: @developer.email, code: code).forgot_password_email.deliver_now

              render json: {
                success: true,
                message: "Verification code sent successfully",
                data: {
                  email: @developer.email
                }
              }, status: :created
            else
              render 'api/v1/shared/error', 
                locals: { 
                  message: 'Failed to create verification code', 
                  errors: forget_password.errors.full_messages 
                }, 
                status: :unprocessable_entity, 
                formats: [:json]
            end
          else
            render 'api/v1/shared/error', 
              locals: { 
                message: 'Developer not found', 
                errors: nil 
              }, 
              status: :not_found, 
              formats: [:json]
          end
        end

        def verify
          if params[:email].blank? || params[:code].blank?
            render 'api/v1/shared/error', 
              locals: { 
                message: 'Failed to verify code', 
                errors: ['Email and code are required'] 
              }, 
              status: :unprocessable_entity, 
              formats: [:json]
            return
          end

          # Find the most recent code for this email within the last hour
          forget_password = ForgetPassword.where(email: params[:email])
                                       .where('created_at > ?', 1.hour.ago)
                                       .order(created_at: :desc)
                                       .first

          if forget_password && forget_password.code.to_s == params[:code].to_s
            render json: {
              success: true,
              message: "Code verified successfully",
              data: {
                email: forget_password.email
              }
            }, status: :ok
          else
            render 'api/v1/shared/error', 
              locals: { 
                message: 'Invalid or expired code', 
                errors: nil 
              }, 
              status: :unauthorized, 
              formats: [:json]
          end
        end

        private

        def forget_password_params
          params.permit(:email, :code)
        end
      end
    end
  end
end




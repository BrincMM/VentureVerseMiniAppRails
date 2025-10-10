module Api
  module V1
    module Developers
      class SessionsController < ApiController
        def verify_password
          developer = Developer.find_by(email: params[:email])
          
          if developer&.valid_password?(params[:password])
            # Update last sign in info (Devise trackable)
            developer.update(
              sign_in_count: developer.sign_in_count + 1,
              current_sign_in_at: Time.current,
              last_sign_in_at: developer.current_sign_in_at,
              current_sign_in_ip: request.remote_ip,
              last_sign_in_ip: developer.current_sign_in_ip
            )
            
            @developer = developer
            render :verify_password, formats: [:json], status: :ok
          else
            render 'api/v1/shared/error', locals: { message: 'Invalid email or password', errors: nil }, status: :unauthorized, formats: [:json]
          end
        end

        def update_password
          developer = Developer.find_by(email: params[:email])

          if developer
            if developer.update(password: params[:password])
              @developer = developer
              render :update_password, formats: [:json], status: :ok
            else
              render 'api/v1/shared/error', locals: { message: 'Failed to update password', errors: developer.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
            end
          else
            render 'api/v1/shared/error', locals: { message: 'Developer not found', errors: nil }, status: :not_found, formats: [:json]
          end
        end
      end
    end
  end
end




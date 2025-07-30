module Api
  module V1
    module Users
      class SessionsController < ApiController
        def verify_password
          user = User.find_by(email: params[:email])
          
          if user&.valid_password?(params[:password])
            @user = user
            render :verify_password, formats: [:json], status: :ok
          else
            render 'api/v1/shared/error', locals: { message: 'Invalid email or password', errors: nil }, status: :unauthorized, formats: [:json]
          end
        end

        def update_password
          user = User.find_by(email: params[:email])

          if user
            if user.update(password: params[:password])
              @user = user
              render :update_password, formats: [:json], status: :ok
            else
              render 'api/v1/shared/error', locals: { message: 'Failed to update password', errors: user.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
            end
          else
            render 'api/v1/shared/error', locals: { message: 'User not found', errors: nil }, status: :not_found, formats: [:json]
          end
        end
      end
    end
  end
end 
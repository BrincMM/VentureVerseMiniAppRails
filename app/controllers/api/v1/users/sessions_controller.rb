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
      end
    end
  end
end 
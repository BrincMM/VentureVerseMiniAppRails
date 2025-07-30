module Api
  module V1
    module Users
      class SessionsController < ApiController
        def verify_password
          user = User.find_by(email: params[:email])
          
          if user&.valid_password?(params[:password])
            render json: {
              success: true,
              message: "User logged in",
              data: user.as_json(
                only: [
                  :id, :email, :google_id, :first_name, :last_name,
                  :country, :age_consent, :avatar, :nick_name,
                  :linkedIn, :twitter, :monthly_credit_balance,
                  :top_up_credit_balance, :tier_id, :created_at, :updated_at
                ],
                methods: [:user_roles]
              )
            }, status: :ok
          else
            render json: {
              success: false,
              message: "Invalid email or password"
            }, status: :unauthorized
          end
        end
      end
    end
  end
end 
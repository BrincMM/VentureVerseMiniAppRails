module Api
  module V1
    class UsersController < ApiController
      def create
        @user = User.new(user_params)
        
        if @user.save
          # 如果提供了用户角色，创建角色
          if params[:user_roles].present?
            params[:user_roles].each do |role|
              role_name = role.downcase.to_sym
              if UserRole.roles.key?(role_name)
                @user.add_role(role_name)
              end
            end
          end
          
          render :create, formats: [:json], status: :created
        else
          render json: {
            success: false,
            message: "Failed to create user",
            errors: @user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(
          :email,
          :google_id,
          :first_name,
          :last_name,
          :age_consent,
          :country,
          :avatar,
          :nick_name,
          :linkedIn,
          :twitter
        )
      end
    end
  end
end 
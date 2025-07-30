module Api
  module V1
    module Users
      class ProfilesController < ApiController
        def show
          @user = User.find_by(email: params[:email])
          
          if @user
            render :show, formats: [:json]
          else
            render 'api/v1/shared/error', locals: { message: 'User not found', errors: nil }, status: :not_found, formats: [:json]
          end
        end

        def update
          @user = User.find_by(email: 'user1@example.com') # 测试用，实际项目中应该是通过认证获取当前用户
          
          if @user.update(user_params)
            # Handle user roles update if roles are provided
            if params[:roles].present?
              @user.user_roles.destroy_all # Remove all existing roles
              params[:roles].each do |role|
                role_name = role.to_s.downcase.strip.to_sym
                @user.add_role(role_name) if UserRole.roles.key?(role_name)
              end
            end
            
            render :update
          else
            render 'api/v1/shared/error', locals: { message: 'Failed to update profile', errors: @user.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
          end
        end

        private

        def user_params
          params.permit(
            :first_name, :last_name, :country,
            :avatar, :nick_name, :linkedIn, :twitter
          )
        end
      end
    end
  end
end
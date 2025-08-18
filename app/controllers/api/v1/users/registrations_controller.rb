module Api
  module V1
    module Users
      class RegistrationsController < ApiController
        def google_signup
          @user = User.new(user_params)
          
          if @user.save
            process_user_roles
            render :user, formats: [:json], status: :created
          else
            render 'api/v1/shared/error', locals: { message: 'Failed to create user', errors: @user.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
          end
        end

        def email_signup
          @user = User.new(user_params)
          
          if @user.save
            process_user_roles
            render :user, formats: [:json], status: :created
          else
            render 'api/v1/shared/error', locals: { message: 'Failed to create user', errors: @user.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
          end
        end

        private

        def user_params
          params.permit(
            :email,
            :google_id,
            :password,
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

        def process_user_roles
          if params[:user_roles].present?
            params[:user_roles].each do |role|
              role_name = role.to_s.downcase.strip.to_sym
              @user.add_role(role_name) if UserRole.roles.key?(role_name)
            end
          end
        end
      end
    end
  end
end 
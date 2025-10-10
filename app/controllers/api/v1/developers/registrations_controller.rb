module Api
  module V1
    module Developers
      class RegistrationsController < ApiController
        def email_signup
          @developer = Developer.new(developer_params)
          
          if @developer.save
            render :email_signup, formats: [:json], status: :created
          else
            render 'api/v1/shared/error', locals: { message: 'Failed to create developer', errors: @developer.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
          end
        end

        private

        def developer_params
          params.permit(
            :email,
            :password,
            :name,
            :github
          )
        end
      end
    end
  end
end




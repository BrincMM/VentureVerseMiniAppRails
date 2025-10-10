module Api
  module V1
    module Developers
      class ProfilesController < ApiController
        def show
          @developer = Developer.find_by(email: params[:email])
          
          if @developer
            render :show, formats: [:json]
          else
            render 'api/v1/shared/error', locals: { message: 'Developer not found', errors: nil }, status: :not_found, formats: [:json]
          end
        end

        def update
          @developer = Developer.find_by(email: params[:email])
          
          unless @developer
            render 'api/v1/shared/error', locals: { message: 'Developer not found', errors: nil }, status: :not_found, formats: [:json]
            return
          end
          
          if @developer.update(developer_params)
            render :update
          else
            render 'api/v1/shared/error', locals: { message: 'Failed to update profile', errors: @developer.errors.full_messages }, status: :unprocessable_entity, formats: [:json]
          end
        end

        private

        def developer_params
          params.permit(
            :name,
            :github
          )
        end
      end
    end
  end
end



module Api
  module V1
    module Users
      class CancelPlanController < ApiController
        def create
          @user = User.find_by(id: params[:user_id])
          
          unless @user
            render 'api/v1/shared/error', 
              locals: { message: 'User not found', errors: nil }, 
              status: :not_found, 
              formats: [:json]
            return
          end

          unless @user.stripe_info&.subscription_status == 'active'
            render 'api/v1/shared/error', 
              locals: { message: 'No active subscription found', errors: nil }, 
              status: :unprocessable_entity, 
              formats: [:json]
            return
          end

          begin
            @user.stripe_info.update!(subscription_status: 'canceled')
            render :create, formats: [:json]
          rescue ActiveRecord::RecordInvalid => e
            render 'api/v1/shared/error', 
              locals: { message: 'Failed to cancel plan', errors: e.record.errors.full_messages }, 
              status: :unprocessable_entity, 
              formats: [:json]
          end
        end

        private

        def cancel_plan_params
          params.permit(:user_id)
        end
      end
    end
  end
end
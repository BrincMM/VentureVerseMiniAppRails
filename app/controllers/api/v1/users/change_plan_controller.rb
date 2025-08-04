module Api
  module V1
    module Users
      class ChangePlanController < ApiController
        def create
          @user = User.find_by(id: params[:user_id])
          
          unless @user
            render 'api/v1/shared/error', 
              locals: { message: 'User not found', errors: nil }, 
              status: :not_found, 
              formats: [:json]
            return
          end

          @tier = Tier.find_by(id: params[:tier_id])
          
          unless @tier
            render 'api/v1/shared/error', 
              locals: { message: 'Tier not found', errors: nil }, 
              status: :not_found, 
              formats: [:json]
            return
          end

          begin
            ActiveRecord::Base.transaction do
              @user.update!(tier_id: @tier.id)
              @user.stripe_info.update!(
                subscription_id: params[:subscription_id],
                stripe_customer_id: params[:stripe_customer_id],
                subscription_status: 'active',
                next_subscription_time: params[:next_subscription_time]
              )
            end
            render :create, formats: [:json]
          rescue ActiveRecord::RecordInvalid => e
            render 'api/v1/shared/error', 
              locals: { message: 'Failed to change plan', errors: e.record.errors.full_messages }, 
              status: :unprocessable_entity, 
              formats: [:json]
          end
        end

        private

        def change_plan_params
          params.permit(:user_id, :tier_id, :subscription_id, :next_subscription_time, :stripe_customer_id)
        end
      end
    end
  end
end
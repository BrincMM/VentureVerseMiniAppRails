module Api
  module V1
    class CreditTopupsController < ApiController
      def create
        user = User.find(credit_topup_params[:user_id])
        @credit_topup = CreditTopup.new(
          user: user,
          credits: credit_topup_params[:credits],
          timestamp: Time.current
        )

        if @credit_topup.save
          user.with_lock do
            user.update!(
              topup_credit_balance: user.topup_credit_balance + @credit_topup.credits
            )
          end
          render :create, status: :created
        else
          render json: {
            success: false,
            message: 'Failed to create credit topup',
            errors: @credit_topup.errors.full_messages
          }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          message: 'User not found',
          errors: ['User not found']
        }, status: :not_found
      end

      private

      def credit_topup_params
        params.permit(:user_id, :credits)
      end
    end
  end
end
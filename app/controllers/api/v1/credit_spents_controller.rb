module Api
  module V1
    class CreditSpentsController < ApiController
      def create
        unless params[:cost].present? && params[:type].present? && params[:user_id].present?
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Cost, type and user ID are required'] },
                      status: :unprocessable_entity
        end

        cost = params[:cost].to_f
        if cost <= 0
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Cost must be greater than 0'] },
                      status: :unprocessable_entity
        end

        unless CreditSpent.spend_types.key?(params[:type])
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', 
                              errors: ["Type must be one of: #{CreditSpent.spend_types.keys.join(', ')}"] },
                      status: :unprocessable_entity
        end

        @user = User.find_by(id: params[:user_id])
        unless @user
          return render 'api/v1/shared/error',
                      locals: { message: 'User not found', errors: ['User does not exist'] },
                      status: :not_found
        end

        credit_amount = CreditSpent.calculate_credit_amount(cost)
        
        if params[:estimation].to_s == 'true'
          @credit_required = credit_amount
          render :estimate
        else
          @credit_spent = CreditSpent.create!(
            user: @user,
            cost_in_usd: cost,
            spend_type: params[:type]
          )
          render :create, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render 'api/v1/shared/error',
               locals: { message: 'Failed to create credit spent record', errors: e.record.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end
module Api
  module V1
    class WaitingListsController < ApiController
      def create
        unless params[:email].present?
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Email is required'] },
                      status: :unprocessable_entity
        end

        # Validate subscribe_type parameter
        subscribe_type = params[:subscribe_type] || 'email'
        unless WaitingList.subscribe_types.key?(subscribe_type)
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', 
                              errors: ["Subscribe type must be one of: #{WaitingList.subscribe_types.keys.join(', ')}"] },
                      status: :unprocessable_entity
        end

        @waiting_list = WaitingList.find_by(email: params[:email])
        
        if @waiting_list
          # Email already exists, return success without creating duplicate
          render :create, status: :ok
        else
          @waiting_list = WaitingList.new(waiting_list_params)
          
          if @waiting_list.save
            render :create, status: :created
          else
            render 'api/v1/shared/error',
                   locals: { message: 'Failed to subscribe to waiting list', errors: @waiting_list.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end

      private

      def waiting_list_params
        params.permit(:email, :subscribe_type)
      end
    end
  end
end

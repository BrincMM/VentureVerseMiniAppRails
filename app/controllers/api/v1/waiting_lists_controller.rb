module Api
  module V1
    class WaitingListsController < ApiController
      def create
        unless params[:email].present?
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Email is required'] },
                      status: :unprocessable_entity
        end

        @waiting_list = WaitingList.find_by(email: params[:email])
        
        if @waiting_list
          # Email already exists, return success without creating duplicate
          render :create, status: :ok
        else
          @waiting_list = WaitingList.new(email: params[:email])
          
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
        params.permit(:email)
      end
    end
  end
end

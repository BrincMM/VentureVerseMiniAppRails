module Api
  module V1
    class AppActivitiesController < ApplicationController
      before_action :authenticate_user!
      
      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Per page must be between 1 and 100'] },
                      status: :unprocessable_entity
        end

        query = AppActivity.recent
        query = query.by_app(params[:app_id]) if params[:app_id].present?
        query = query.by_type(params[:activity_type]) if params[:activity_type].present?
        
        @total_count = query.count
        @app_activities = query.page(params[:page]).per(per_page)
        
        render :index
      end

      def create
        @app_activity = AppActivity.new(app_activity_params)
        @app_activity.user = current_user
        @app_activity.timestamp = Time.current

        if @app_activity.save
          render :create, status: :created
        else
          render 'api/v1/shared/error',
                locals: { message: 'Failed to create app activity', errors: @app_activity.errors.full_messages },
                status: :unprocessable_entity
        end
      end

      private

      def app_activity_params
        params.require(:app_activity).permit(:app_id, :activity_type, :app_meta)
      end
    end
  end
end
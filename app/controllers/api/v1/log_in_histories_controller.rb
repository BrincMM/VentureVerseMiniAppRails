module Api
  module V1
    class LogInHistoriesController < ApiController
      def create
        metadata_param = params.dig(:log_in_history, :metadata)

        @log_in_history = LogInHistory.new(log_in_history_params)
        @log_in_history.metadata = normalize_metadata(metadata_param)
        @log_in_history.timestamp = Time.current

        unless @log_in_history.save
          return render 'api/v1/shared/error',
                      locals: { message: 'Failed to create login history', errors: @log_in_history.errors.full_messages },
                      status: :unprocessable_entity
        end

        render :create
      end

      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Per page must be between 1 and 100'] },
                      status: :unprocessable_entity
        end

        query = LogInHistory.all
        query = query.where(user_id: params[:user_id]) if params[:user_id].present?
        
        if params[:start_date].present? && params[:end_date].present?
          begin
            start_date = Time.zone.parse(params[:start_date])
            end_date = Time.zone.parse(params[:end_date])
            
            if start_date.nil? || end_date.nil?
              return render 'api/v1/shared/error',
                          locals: { message: 'Invalid date format', errors: ['Start date and end date must be valid dates'] },
                          status: :unprocessable_entity
            end
            
            query = query.where(timestamp: start_date.beginning_of_day..end_date.end_of_day)
          rescue ArgumentError
            return render 'api/v1/shared/error',
                        locals: { message: 'Invalid date format', errors: ['Start date and end date must be valid dates'] },
                        status: :unprocessable_entity
          end
        end

        @total_count = query.count
        @log_in_histories = query.order(timestamp: :desc).page(params[:page]).per(per_page)
        
        render :index
      end

      private

      def log_in_history_params
        params.require(:log_in_history).permit(:user_id)
      end

      def normalize_metadata(metadata)
        return if metadata.nil?

        if metadata.is_a?(ActionController::Parameters)
          metadata = metadata.permit!.to_h
        end

        return metadata if metadata.is_a?(String)

        metadata.to_json
      end
    end
  end
end
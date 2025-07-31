module Api
  module V1
    class AppsController < ApiController
      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Per page must be between 1 and 100'] },
                      status: :unprocessable_entity
        end

        query = App.all
        query = query.by_category(params[:category]) if params[:category].present?
        query = query.by_sector(params[:sector]) if params[:sector].present?
        query = query.with_any_tags(params[:tags].split(',')) if params[:tags].present?

        @total_count = query.count
        @apps = query.order(created_at: :desc, id: :desc).page(params[:page]).per(per_page)
        
        render :index
      end
    end
  end
end
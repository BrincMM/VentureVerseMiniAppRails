module Api
  module V1
    module Users
      class PerksController < ApiController
        def index
          user = User.find_by(id: params[:user_id])
          unless user
            return render 'api/v1/shared/error',
                        locals: { message: 'User not found', errors: ['User does not exist'] },
                        status: :not_found
          end

          per_page = params.fetch(:per_page, 10).to_i
          if per_page <= 0 || per_page > 100
            return render 'api/v1/shared/error',
                        locals: { message: 'Invalid parameters', errors: ['Per page must be between 1 and 100'] },
                        status: :unprocessable_entity
          end

          query = user.accessible_perks
          query = query.by_category(params[:category]) if params[:category].present?
          query = query.by_sector(params[:sector]) if params[:sector].present?
          query = query.with_any_tags(params[:tags].split(',')) if params[:tags].present?

          @total_count = query.count
          @perks = query.order(partner_name: :asc, id: :asc).page(params[:page]).per(per_page)

          render :index
        end
      end
    end
  end
end





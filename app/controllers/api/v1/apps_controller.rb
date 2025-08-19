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
        @apps = query.order(sort_order: :asc, id: :asc).page(params[:page]).per(per_page)
        
        render :index
      end

      def add_access
        unless params[:user_id].present? && params[:app_ids].present?
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['User ID and App IDs are required'] },
                      status: :unprocessable_entity
        end

        user = User.find_by(id: params[:user_id])
        unless user
          return render 'api/v1/shared/error',
                      locals: { message: 'User not found', errors: ['User does not exist'] },
                      status: :not_found
        end

        app_ids = Array(params[:app_ids])
        apps = App.where(id: app_ids)
        
        if apps.count != app_ids.count
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid app IDs', errors: ['One or more apps do not exist'] },
                      status: :not_found
        end

        app_ids.each do |app_id|
          # 如果访问权限已存在，跳过创建
          next if AppAccess.exists?(user_id: user.id, app_id: app_id)

          access = AppAccess.new(user_id: user.id, app_id: app_id)
          unless access.save
            return render 'api/v1/shared/error',
                      locals: { message: 'Failed to grant access', errors: [access.errors.full_messages.join(', ')] },
                      status: :unprocessable_entity
          end
        end

        render json: {
          success: true,
          message: 'Access granted successfully'
        }
      end

      def remove_access
        unless params[:user_id].present? && params[:app_ids].present?
          return render json: {
            success: false,
            message: 'Invalid parameters',
            errors: ['User ID and App IDs are required']
          }, status: :unprocessable_entity
        end

        user = User.find_by(id: params[:user_id])
        unless user
          return render 'api/v1/shared/error',
                      locals: { message: 'User not found', errors: ['User does not exist'] },
                      status: :not_found
        end

        app_ids = Array(params[:app_ids])
        accesses = AppAccess.where(user_id: user.id, app_id: app_ids)
        
        if accesses.empty?
          return render 'api/v1/shared/error',
                      locals: { message: 'No access found', errors: ['User does not have access to any of the specified apps'] },
                      status: :not_found
        end

        removed_count = accesses.destroy_all.count

        render json: {
          success: true,
          message: 'Access removed successfully'
        }
      end

    end
  end
end
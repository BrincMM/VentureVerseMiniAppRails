module Api
  module V1
    class AppsController < ApiController
      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

      before_action :set_app, only: [:update, :destroy]

      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render_general_error(
            message: 'Invalid parameters',
            errors: ['Per page must be between 1 and 100'],
            status: :unprocessable_entity
          )
        end

        query = App.published
        query = query.by_category(params[:category_id]) if params[:category_id].present?
        query = query.by_sector(params[:sector_id]) if params[:sector_id].present?
        query = query.with_any_tags(params[:tags].split(',')) if params[:tags].present?

        @total_count = query.count
        @apps = query.order(sort_order: :asc, id: :asc).page(params[:page]).per(per_page)

        render :index
      end

      def filters
        query = App.published
        query = query.by_category(params[:category_id]) if params[:category_id].present?
        query = query.by_sector(params[:sector_id]) if params[:sector_id].present?

        tag_list = []
        if params[:tags].present?
          tag_list = parse_filter_tags(params[:tags])
          query = query.with_any_tags(tag_list) if tag_list.present?
        end

        filtered_apps = App.where(id: query.select(:id))

        category_counts = filtered_apps.group(:category_id).count
        sector_counts = filtered_apps.group(:sector_id).count

        categories = Category.where(id: category_counts.keys).index_by(&:id)
        sectors = Sector.where(id: sector_counts.keys).index_by(&:id)

        @used_categories = category_counts.each_with_object([]) do |(category_id, count), collection|
          category = categories[category_id]
          next unless category

          collection << { id: category.id, name: category.name, count: count }
        end.sort_by { |category| category[:name].to_s.downcase }

        @used_sectors = sector_counts.each_with_object([]) do |(sector_id, count), collection|
          sector = sectors[sector_id]
          next unless sector

          collection << { id: sector.id, name: sector.name, count: count }
        end.sort_by { |sector| sector[:name].to_s.downcase }

        tag_counts = ActsAsTaggableOn::Tagging
                     .joins(:tag)
                     .where(taggable_type: 'App', taggable_id: filtered_apps.select(:id))
                     .group('tags.name')
                     .order('tags.name ASC')
                     .count

        @used_tags = if tag_list.present?
                       tag_list.each_with_object([]) do |tag_name, collection|
                         count = tag_counts[tag_name]
                         next unless count

                         collection << { name: tag_name, count: count }
                       end
                     else
                       tag_counts.map do |name, count|
                         { name: name, count: count }
                       end
                     end

        render :filters
      end

      def create
        permitted_params = app_params
        attributes = permitted_params.except(:tags)

        @app = App.new(attributes)
        assign_tags(@app, permitted_params[:tags])

        if @app.save
          render :create, status: :created
        else
          render_general_error(
            message: 'Failed to create app',
            errors: @app.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        permitted_params = app_params
        attributes = permitted_params.except(:tags)

        assign_tags(@app, permitted_params[:tags]) if permitted_params.key?(:tags)

        if @app.update(attributes)
          render :update
        else
          render_general_error(
            message: 'Failed to update app',
            errors: @app.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        if @app.destroy
          render :destroy
        else
          render_general_error(
            message: 'Failed to delete app',
            errors: @app.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def add_access
        unless params[:user_id].present? && params[:app_ids].present?
          return render_general_error(
            message: 'Invalid parameters',
            errors: ['User ID and App IDs are required'],
            status: :unprocessable_entity
          )
        end

        user = User.find_by(id: params[:user_id])
        unless user
          return render_general_error(
            message: 'User not found',
            errors: ['User does not exist'],
            status: :not_found
          )
        end

        app_ids = Array(params[:app_ids])
        apps = App.where(id: app_ids)

        if apps.count != app_ids.count
          return render_general_error(
            message: 'Invalid app IDs',
            errors: ['One or more apps do not exist'],
            status: :not_found
          )
        end

        app_ids.each do |app_id|
          next if AppAccess.exists?(user_id: user.id, app_id: app_id)

          access = AppAccess.new(user_id: user.id, app_id: app_id)
          unless access.save
            return render_general_error(
              message: 'Failed to grant access',
              errors: access.errors.full_messages,
              status: :unprocessable_entity
            )
          end
        end

        render json: {
          success: true,
          message: 'Access granted successfully'
        }
      end

      def remove_access
        unless params[:user_id].present? && params[:app_ids].present?
          return render_general_error(
            message: 'Invalid parameters',
            errors: ['User ID and App IDs are required'],
            status: :unprocessable_entity
          )
        end

        user = User.find_by(id: params[:user_id])
        unless user
          return render_general_error(
            message: 'User not found',
            errors: ['User does not exist'],
            status: :not_found
          )
        end

        app_ids = Array(params[:app_ids])
        accesses = AppAccess.where(user_id: user.id, app_id: app_ids)

        if accesses.empty?
          return render_general_error(
            message: 'No access found',
            errors: ['User does not have access to any of the specified apps'],
            status: :not_found
          )
        end

        accesses.destroy_all

        render json: {
          success: true,
          message: 'Access removed successfully'
        }
      end

      private

      def app_params
        params.require(:app).permit(:name, :description, :app_url, :category_id, :sector_id, :sort_order, :status, :developer_id, :rate_limit_requests_per_day, :rate_limit_requests_per_minute, tags: [])
      end

      def set_app
        @app = App.find_by(id: params[:id])
        return if @app

        render_general_error(
          message: 'App not found',
          errors: ['App does not exist'],
          status: :not_found
        ) and return
      end

      def assign_tags(app, tags)
        return if tags.nil?

        tag_list = case tags
                   when String
                     tags.split(',')
                   when Array
                     tags
                   else
                     []
                   end

        tag_list = tag_list.map { |tag| tag.to_s.strip }.reject(&:blank?)
        app.tag_list = tag_list
      end

      def parse_filter_tags(value)
        case value
        when String
          value.split(',').map(&:strip).reject(&:blank?)
        when Array
          value.map(&:to_s).map(&:strip).reject(&:blank?)
        else
          []
        end
      end

      def handle_parameter_missing(exception)
        render_general_error(
          message: 'Invalid parameters',
          errors: ["#{exception.param.to_s.humanize} parameters are required"],
          status: :unprocessable_entity
        )
      end

      def render_general_error(message:, errors:, status:)
        render 'api/v1/general/errors',
               locals: { message: message, errors: Array(errors) },
               status: status
      end
    end
  end
end
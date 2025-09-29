module Api
  module V1
    class SectorsController < ApiController
      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render_general_error(
            message: 'Invalid parameters',
            errors: ['Per page must be between 1 and 100'],
            status: :unprocessable_entity
          )
        end

        query = Sector.ordered_by_name
        query = query.where('LOWER(name) LIKE ?', "%#{params[:search].downcase}%") if params[:search].present?

        @total_count = query.count
        @sectors = query.page(params[:page]).per(per_page)

        render :index
      end

      def create
        @sector = Sector.new(sector_params)

        if @sector.save
          render :create, status: :created
        else
          render_general_error(
            message: 'Failed to create sector',
            errors: @sector.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        @sector = Sector.find_by(id: params[:id])
        unless @sector
          return render_general_error(
            message: 'Sector not found',
            errors: ['Sector does not exist'],
            status: :not_found
          )
        end

        if @sector.update(sector_params)
          render :update
        else
          render_general_error(
            message: 'Failed to update sector',
            errors: @sector.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        @sector = Sector.find_by(id: params[:id])
        unless @sector
          return render_general_error(
            message: 'Sector not found',
            errors: ['Sector does not exist'],
            status: :not_found
          )
        end

        if @sector.destroy
          render :destroy
        else
          render_general_error(
            message: 'Failed to delete sector',
            errors: @sector.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      private

      def sector_params
        params.require(:sector).permit(:name)
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


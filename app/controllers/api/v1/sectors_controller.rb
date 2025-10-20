module Api
  module V1
    class SectorsController < ApiController
      before_action :set_sector, only: [:update, :destroy]

      def index
        per_page = validate_pagination_params
        return unless per_page

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

      def set_sector
        @sector = Sector.find_by(id: params[:id])
        return if @sector

        render_general_error(
          message: 'Sector not found',
          errors: ['Sector does not exist'],
          status: :not_found
        )
      end

      def sector_params
        params.require(:sector).permit(:name)
      end
    end
  end
end


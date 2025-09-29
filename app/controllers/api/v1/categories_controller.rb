module Api
  module V1
    class CategoriesController < ApiController
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

        query = Category.ordered_by_name
        query = query.where('LOWER(name) LIKE ?', "%#{params[:search].downcase}%") if params[:search].present?

        @total_count = query.count
        @categories = query.page(params[:page]).per(per_page)

        render :index
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          render :create, status: :created
        else
          render_general_error(
            message: 'Failed to create category',
            errors: @category.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        @category = Category.find_by(id: params[:id])
        unless @category
          return render_general_error(
            message: 'Category not found',
            errors: ['Category does not exist'],
            status: :not_found
          )
        end

        if @category.update(category_params)
          render :update
        else
          render_general_error(
            message: 'Failed to update category',
            errors: @category.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        @category = Category.find_by(id: params[:id])
        unless @category
          return render_general_error(
            message: 'Category not found',
            errors: ['Category does not exist'],
            status: :not_found
          )
        end

        if @category.destroy
          render :destroy
        else
          render_general_error(
            message: 'Failed to delete category',
            errors: @category.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
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


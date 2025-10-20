module Api
  module V1
    class CategoriesController < ApiController
      before_action :set_category, only: [:update, :destroy]

      def index
        per_page = validate_pagination_params
        return unless per_page

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

      def set_category
        @category = Category.find_by(id: params[:id])
        return if @category

        render_general_error(
          message: 'Category not found',
          errors: ['Category does not exist'],
          status: :not_found
        )
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end


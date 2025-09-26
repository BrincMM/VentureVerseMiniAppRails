module Api
  module V1
    class PerksController < ApiController
      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

      def index
        per_page = params.fetch(:per_page, 10).to_i
        if per_page <= 0 || per_page > 100
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['Per page must be between 1 and 100'] },
                      status: :unprocessable_entity
        end

        query = Perk.all
        query = query.by_category(params[:category]) if params[:category].present?
        query = query.by_sector(params[:sector]) if params[:sector].present?
        query = query.with_any_tags(params[:tags].split(',')) if params[:tags].present?

        @total_count = query.count
        @perks = query.order(partner_name: :asc, id: :asc).page(params[:page]).per(per_page)

        render :index
      end

      def create
        @perk = Perk.new(perk_params)
        assign_tags(@perk)

        if @perk.save
          render :create, status: :created
        else
          render 'api/v1/shared/error',
                 locals: { message: 'Failed to create perk', errors: @perk.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        @perk = Perk.find_by(id: params[:id])
        unless @perk
          return render 'api/v1/shared/error',
                      locals: { message: 'Perk not found', errors: ['Perk does not exist'] },
                      status: :not_found
        end

        @perk.assign_attributes(perk_params)
        assign_tags(@perk)

        if @perk.save
          render :update
        else
          render 'api/v1/shared/error',
                 locals: { message: 'Failed to update perk', errors: @perk.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        perk = Perk.find_by(id: params[:id])
        unless perk
          return render 'api/v1/shared/error',
                      locals: { message: 'Perk not found', errors: ['Perk does not exist'] },
                      status: :not_found
        end

        tags_snapshot = perk.tag_list.dup
        @perk = perk

        if perk.destroy
          @perk.tag_list = tags_snapshot
          render :destroy
        else
          render 'api/v1/shared/error',
                 locals: { message: 'Failed to delete perk', errors: perk.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def perk_params
        params.require(:perk).permit(:partner_name, :category, :sector, :company_website, :contact_email, :contact)
      end

      def assign_tags(perk)
        return unless params[:perk].is_a?(ActionController::Parameters)

        if params[:perk].key?(:tags)
          perk.tag_list = parse_tags(params[:perk][:tags])
        end
      end

      def parse_tags(value)
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
        render 'api/v1/shared/error',
               locals: { message: 'Invalid parameters', errors: ["#{exception.param.to_s.humanize} parameters are required"] },
               status: :unprocessable_entity
      end
    end
  end
end


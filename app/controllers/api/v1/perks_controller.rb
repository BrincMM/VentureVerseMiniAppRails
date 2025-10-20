module Api
  module V1
    class PerksController < ApiController
      before_action :set_perk, only: [:update, :destroy]

      def index
        per_page = validate_pagination_params
        return unless per_page

        query = Perk.all
        query = query.by_category(params[:category_id]) if params[:category_id].present?
        query = query.by_sector(params[:sector_id]) if params[:sector_id].present?
        query = query.with_any_tags(parse_tags(params[:tags])) if params[:tags].present?

        @total_count = query.count
        @perks = query.order(partner_name: :asc, id: :asc).page(params[:page]).per(per_page)

        render :index
      end

      def filters
        query = Perk.all
        query = query.by_category(params[:category_id]) if params[:category_id].present?
        query = query.by_sector(params[:sector_id]) if params[:sector_id].present?

        tag_list = []
        if params[:tags].present?
          tag_list = parse_tags(params[:tags])
          query = query.with_any_tags(tag_list) if tag_list.present?
        end

        category_counts = query.group(:category_id).count
        sector_counts = query.group(:sector_id).count

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
                     .where(taggable_type: Perk.name, taggable_id: query.select(:id))
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
        permitted_params = perk_params
        attributes = permitted_params.except(:tags)

        @perk = Perk.new(attributes)
        assign_tags(@perk, permitted_params[:tags])

        if @perk.save
          render :create, status: :created
        else
          render_general_error(
            message: 'Failed to create perk',
            errors: @perk.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        permitted_params = perk_params
        attributes = permitted_params.except(:tags)

        assign_tags(@perk, permitted_params[:tags]) if permitted_params.key?(:tags)

        if @perk.update(attributes)
          render :update
        else
          render_general_error(
            message: 'Failed to update perk',
            errors: @perk.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        tags_snapshot = @perk.tag_list.dup

        if @perk.destroy
          @perk.tag_list = tags_snapshot
          render :destroy
        else
          render_general_error(
            message: 'Failed to delete perk',
            errors: @perk.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      private

      def set_perk
        @perk = Perk.find_by(id: params[:id])
        return if @perk

        render_general_error(
          message: 'Perk not found',
          errors: ['Perk does not exist'],
          status: :not_found
        )
      end

      def perk_params
        params.require(:perk).permit(:partner_name, :category_id, :sector_id, :company_website, :contact_email, :contact, :tags, tags: [])
      end
    end
  end
end


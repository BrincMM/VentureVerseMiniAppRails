module Api
  module V1
    class TiersController < ApiController
      def index
        @tiers = Tier.active.order(monthly_tier_price: :asc)
        render :index
      end
    end
  end
end
module Api
  class HealthController < ApiController
    def index
      render json: {
        status: "up",
        timestamp: Time.current,
        environment: Rails.env
      }
    end
  end
end 
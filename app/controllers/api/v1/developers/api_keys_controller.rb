module Api
  module V1
    module Developers
      class ApiKeysController < ApiController
        # POST /api/v1/developers/apps/:app_id/api_keys/rotate
        def rotate
          app = App.find_by(id: params[:app_id])
          
          unless app
            render 'api/v1/shared/error', 
                   locals: { message: 'App not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          # Find current active key (if exists)
          current_key = app.api_keys.find_by(status: :active)
          
          # Determine rate limits
          rate_limit_per_minute = params[:rate_limit_per_minute] || current_key&.rate_limit_per_minute || 100
          rate_limit_per_day = params[:rate_limit_per_day] || current_key&.rate_limit_per_day || 10000
          expires_at = params[:expires_at] || current_key&.expires_at
          
          # Use transaction to ensure atomicity
          ActiveRecord::Base.transaction do
            # Expire the current key if it exists
            current_key.update!(status: :expired) if current_key
            
            # Create new active key
            @api_key = app.api_keys.create!(
              status: :active,
              rate_limit_per_minute: rate_limit_per_minute,
              rate_limit_per_day: rate_limit_per_day,
              expires_at: expires_at
            )
          end
          
          render :rotate, formats: [:json], status: :created
        rescue ActiveRecord::RecordInvalid => e
          render 'api/v1/shared/error', 
                 locals: { message: 'Failed to rotate API key', errors: e.record.errors.full_messages }, 
                 status: :unprocessable_entity, 
                 formats: [:json]
        end
      end
    end
  end
end


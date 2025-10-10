module Api
  module V1
    class ApiKeysController < ApiController
      # POST /api/v1/api_keys/validate
      def validate
        key = params[:key]
        
        unless key.present?
          render 'api/v1/shared/error', 
                 locals: { message: 'API key is required', errors: nil }, 
                 status: :bad_request, 
                 formats: [:json]
          return
        end
        
        @api_key = ApiKey.find_by(api_key: key)
        
        unless @api_key
          render 'api/v1/shared/error', 
                 locals: { message: 'Invalid API key', errors: nil }, 
                 status: :unauthorized, 
                 formats: [:json]
          return
        end
        
        # Check if key is valid for use (active and not expired)
        unless @api_key.valid_for_use?
          status_message = @api_key.expired? ? 'expired' : 'revoked'
          render 'api/v1/shared/error', 
                 locals: { message: "API key is #{status_message}", errors: nil }, 
                 status: :unauthorized, 
                 formats: [:json]
          return
        end
        
        # Update last used timestamp
        @api_key.record_usage!
        
        # Load associated app and developer for response
        @app = @api_key.app
        @developer = @app.developer
        
        render :validate, formats: [:json]
      end
    end
  end
end


class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :set_default_format
  before_action :authenticate_api_key

  private

  def set_default_format
    request.format = :json
  end

  def authenticate_api_key
    authenticate_or_request_with_http_token do |token, _options|
      return false if token.blank?
      valid_api_key?(token)
    end
  end

  def valid_api_key?(key)
    return false if key.blank?
    Rails.application.credentials.api_keys.include?(key)
  end

  private

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end 
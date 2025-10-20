class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :set_default_format
  before_action :authenticate_api_key

  # Pagination constants
  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 100

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

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

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # Shared error handling
  def render_general_error(message:, errors:, status:)
    render 'api/v1/general/errors',
           locals: { message: message, errors: Array(errors) },
           status: status
  end

  def handle_parameter_missing(exception)
    render_general_error(
      message: 'Invalid parameters',
      errors: ["#{exception.param.to_s.humanize} parameters are required"],
      status: :unprocessable_entity
    )
  end

  # Shared tag parsing methods
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

  def assign_tags(record, tags)
    return if tags.nil?

    tag_list = case tags
               when String
                 tags.split(',')
               when Array
                 tags
               else
                 []
               end

    tag_list = tag_list.map { |tag| tag.to_s.strip }.reject(&:blank?)
    record.tag_list = tag_list
  end

  # Pagination validation
  def validate_pagination_params
    per_page = params.fetch(:per_page, DEFAULT_PER_PAGE).to_i
    if per_page <= 0 || per_page > MAX_PER_PAGE
      render_general_error(
        message: 'Invalid parameters',
        errors: ["Per page must be between 1 and #{MAX_PER_PAGE}"],
        status: :unprocessable_entity
      )
      return nil
    end
    per_page
  end
end 
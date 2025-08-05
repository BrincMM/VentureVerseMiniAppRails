ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers

    def api_token_headers
      token = Rails.application.credentials.api_keys.first
      { 'Authorization' => "Bearer #{token}" }
    end

    def get_with_token(path, **args)
      args[:headers] ||= {}
      args[:headers].merge!(api_token_headers)
      get path, **args
    end

    def post_with_token(path, **args)
      args[:headers] ||= {}
      args[:headers].merge!(api_token_headers)
      post path, **args
    end

    def put_with_token(path, **args)
      args[:headers] ||= {}
      args[:headers].merge!(api_token_headers)
      put path, **args
    end

    def patch_with_token(path, **args)
      args[:headers] ||= {}
      args[:headers].merge!(api_token_headers)
      patch path, **args
    end

    def delete_with_token(path, **args)
      args[:headers] ||= {}
      args[:headers].merge!(api_token_headers)
      delete path, **args
    end
  end
end

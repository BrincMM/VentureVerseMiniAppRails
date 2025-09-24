require 'net/http'
require 'uri'
require 'json'

module Beehiiv
  class SubscribeService
    PUBLICATION_ID = 'pub_6822cfbb-c521-4a1e-8b14-7dc499eb78b5'

    Result = Struct.new(:success, :status, :body, keyword_init: true) do
      def success?
        success
      end
    end

    def self.subscribe(waiting_list)
      api_key = Rails.application.credentials.dig(:beehiiv_api_key)
      unless api_key.present?
        return update_and_result(waiting_list, false, nil, 'Missing beehiiv_api_key credential', [])
      end

      url = URI("https://api.beehiiv.com/v2/publications/#{PUBLICATION_ID}/subscriptions")

      custom_fields = []

      first_name = waiting_list.first_name.to_s.strip
      full_name = (waiting_list.name.presence || [waiting_list.first_name, waiting_list.last_name].join(' ')).to_s.strip

      custom_fields << { name: 'First Name', value: first_name } if first_name.present?
      custom_fields << { name: 'Full Name', value: full_name } if full_name.present?

      payload = {
        email: waiting_list.email,
        send_welcome_email: false,
        utm_source: 'Venture Verse',
        referring_site: 'www.ventureverse.com'
      }
      payload[:custom_fields] = custom_fields if custom_fields.any?

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 5

      request = Net::HTTP::Post.new(url)
      request['Authorization'] = "Bearer #{api_key}"
      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(payload)

      begin
        response = http.request(request)
        status = response.code.to_i
        body = parse_json(response.body)

        if status.between?(200, 299)
          subscriber_id = extract_subscriber_id(body)
          update_and_result(waiting_list, true, status, body, subscriber_id)
        else
          reason = "HTTP #{status}: #{extract_error_message(body)}"
          update_and_result(waiting_list, false, status, body, nil, reason)
        end
      rescue => e
        reason = e.message
        update_and_result(waiting_list, false, nil, nil, nil, reason)
      end
    end

    def self.parse_json(text)
      JSON.parse(text)
    rescue JSON::ParserError
      { 'raw' => text }
    end
    private_class_method :parse_json

    def self.extract_error_message(body)
      return body if body.is_a?(String)
      if body.is_a?(Hash)
        # Beehiiv v2 error shape example:
        # { "status": 0, "statusText": "string", "errors": [ {"message":"...","code":"..."} ] }
        messages = []
        messages << body['statusText'] if body['statusText'].present?
        if body['errors'].is_a?(Array)
          detailed = body['errors'].map do |err|
            next unless err.is_a?(Hash)
            parts = []
            parts << err['message'] if err['message'].present?
            parts << "(code: #{err['code']})" if err['code'].present?
            parts.compact.join(' ')
          end.compact
          messages << detailed.join('; ') if detailed.any?
        end
        return messages.reject(&:blank?).join(' - ') if messages.any?
        return body['message'] if body['message']
      end
      body.to_s
    end
    private_class_method :extract_error_message

    def self.extract_subscriber_id(body)
      return nil unless body.is_a?(Hash)
      # Beehiiv v2 success shape: { "data": { "id": "sub_...", ... } }
      body.dig('data', 'id') || body['id']
    end
    private_class_method :extract_subscriber_id

    def self.update_and_result(waiting_list, success, status, body, subscriber_id, reason = nil)
      begin
        waiting_list.update(
          beehiiv_synced_at: Time.current,
          beehiiv_sync_is_success: success,
          beehiiv_sync_error: reason,
          beehiiv_subscriber_id: subscriber_id
        )
      rescue => e
        Rails.logger.error("Failed to update Beehiiv sync tracking for WaitingList##{waiting_list.id}: #{e.message}")
      end

      Result.new(success: success, status: status, body: body)
    end
    private_class_method :update_and_result
  end
end



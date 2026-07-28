require 'base64'

module Mobysuite
  module GC2
    class Sso
      TEST_URL = "https://sso-test.mobysuite.com/oauth/token".freeze
      PRODUCTION_URL = "https://sso.mobysuite.com/oauth/token".freeze
      TEST_INTROSPECT_URL =
        "https://sso-test.mobysuite.com/oauth/introspect".freeze
      PRODUCTION_INTROSPECT_URL =
        "https://sso.mobysuite.com/oauth/introspect".freeze

      def self.environment
        if defined?(Rails) && Rails.respond_to?(:env)
          Rails.env.to_s
        else
          ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "production"
        end
      end

      def self.test_environment?
        %w[development test].include?(environment)
      end

      class TokenIntrospector
        attr_reader :endpoint

        Result = Struct.new(:active, :claims, :error) do
          def active?
            active
          end
        end

        def self.call(token, customer)
          new.call(token, customer)
        end

        def initialize(endpoint = nil, timeout = nil)
          @endpoint = endpoint || default_endpoint
          @timeout = timeout || ENV.fetch("SSO_TIMEOUT_MS", 5_000).to_i / 1000.0
        end

        def call(token, customer)
          return failure("empty_token") if empty?(token)
          return failure("empty_customer") if empty?(customer)
          return failure("sso_not_configured") if empty?(@endpoint)

          response = HTTParty.post(
            @endpoint,
            headers: {
              'Mobysuite-Customer' => customer,
              'Content-Type' => 'application/x-www-form-urlencoded'
            },
            body: { token: token },
            timeout: @timeout,
            open_timeout: 5
          )
          body = response.parsed_response
          body = {} unless body.is_a?(Hash)

          if response.success? && body["active"] == true
            Result.new(true, body, nil)
          else
            failure("inactive_token")
          end
        rescue Net::OpenTimeout, Net::ReadTimeout, Timeout::Error
          failure("sso_timeout")
        rescue StandardError
          failure("sso_unreachable")
        end

        private

        def default_endpoint
          if Sso.test_environment?
            Sso::TEST_INTROSPECT_URL
          else
            Sso::PRODUCTION_INTROSPECT_URL
          end
        end

        def empty?(value)
          value.nil? || value.to_s.strip.empty?
        end

        def failure(reason)
          Result.new(false, {}, reason)
        end
      end

      attr_reader :sso_url

      def initialize(client_id = nil, client_secret = nil)
        @client_id = ENV["MOBYSUITE_GC2_CLIENT_ID"] || client_id
        @client_secret = ENV["MOBYSUITE_GC2_CLIENT_SECRET"] || client_secret
        @sso_url = self.class.test_environment? ? TEST_URL : PRODUCTION_URL
      end

      def login(data)
        response = HTTParty.post(
          sso_url,
          headers: {
            'Mobysuite-Customer' => data[:customer],
            'Content-Type' => 'application/x-www-form-urlencoded',
            'Authorization' => basic_auth
          },
          body: {
            grant_type: 'password',
            username: data[:username],
            password: data[:password]
          }
        )

        normalize_response(response)
      end

      alias_method :authenticate, :login

      def validate_token(token, customer)
        TokenIntrospector.call(token, customer)
      end

      private

      def basic_auth
        credentials = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
        "Basic #{credentials}"
      end

      def normalize_response(response)
        result = {
          response: response.success?,
          body: response.parsed_response
        }
        result[:response_code] = response.code unless response.success?
        result
      end
    end
  end
end

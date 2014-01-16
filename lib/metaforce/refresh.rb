require 'faraday'

module Metaforce

  # This class supports obtaining a new OAuth 2 access token through the
  # refresh flow.
  class Refresh

    # Proc to call to reauthenticate.
    # @return [Proc]
    def self.authentication_handler
      @authentication_handler ||=
        lambda { |_, options| Metaforce.refresh(options) }
    end

    # @param options [Hash]
    # @option refresh_token [String]
    # @option client_id [String]
    # @option client_secret [String]
    # @option host [String] Hostname for authentication requests.
    # @option authentication_calls [Proc] A proc that is called with the
    #   response body if the refresh is successful.
    def initialize(options = {})
      @options = options
    end

    # Perform the refresh request.
    #
    # @result [Hash] Returns a hash with the session_id.
    def refresh
      response = connection.post('/services/oauth2/token') do |req|
        req.body = URI.encode_www_form(params)
      end
      raise error_message(response) if response.status != 200

      if @options[:authentication_callback]
        @options[:authentication_callback].call(response.body)
      end

      { :session_id => response.body['access_token'] }
    end

    # Params for the refresh request.
    #
    # @return [Hash]
    def params
      {
        :grant_type    => 'refresh_token',
        :refresh_token => @options[:refresh_token],
        :client_id     => @options[:client_id],
        :client_secret => @options[:client_secret]
      }
    end
    private :params

    # @return [String]
    def error_message(response)
      "#{response.body['error']}: #{response.body['error_description']}"
    end
    private :error_message

    # Hostname for authentication requests.
    # @return [String]
    def host
      @options[:host] || Metaforce.configuration.host
    end
    private :host

    # URL for authentication requests.
    # @return [String]
    def login_url
      "https://#{host}"
    end
    private :login_url

    # Faraday connection to use when sending an authentication request.
    def connection
      @connection ||= Faraday.new(login_url) do |builder|
        builder.response :json
        builder.adapter Faraday.default_adapter
      end
    end
    private :connection

  end

end

require 'faraday'
require 'faraday_middleware'

module MediumSdk::Connection
  class IntegrationToken
    attr_accessor :http
    attr_accessor :token

    def initialize(opts = {})
      @endpoint = 'https://api.medium.com/v1/'
      @token = opts[:integration_token] if opts.key? :integration_token
      set_client
    end

    def set_client()
      headers = {
        'Host' => 'api.medium.com',
        'Authorization' => 'Bearer ' + @token,
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Accept-Charset' => 'utf-8'
      }
      @http  = Faraday.new(url: @endpoint, headers: headers) do |conn|
        conn.request :multipart
        conn.request :json
        conn.response :json, content_type: 'application/json'
        conn.adapter  Faraday.default_adapter
      end
    end

  end
end

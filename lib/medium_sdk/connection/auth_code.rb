require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/oauth2_refresh'
require 'oauth2'

module MediumSdk::Connection
  class AuthCode
    OAUTH_HOST = 'https://medium.com'
    OAUTH_AUTHZ_ENDPOINT = '/m/oauth/authorize'
    OAUTH_TOKEN_ENDPOINT = '/m/oauth/token'
    API_HOST = 'https://api.medium.com'
    API_VERSION = 'v1'

    attr_reader :client_id

    attr_accessor :oauth2client
    attr_accessor :oauth_redirect_uri
    attr_accessor :http
    attr_accessor :token

    def initialize(opts = {})
      init_attributes
      @client_id = opts[:client_id] if opts.key? :client_id
      @client_secret = opts[:client_secret] if opts.key? :client_secret
      @oauth_redirect_uri = opts[:oauth_redirect_uri] if opts.key? :oauth_redirect_uri
      @scope = opts[:scope] if opts.key? :scope
      @oauth2client = new_oauth2_client()
    end

    def init_attributes()
      @token = nil
      @http = nil
      @instance_headers = nil
    end

    def set_token(token)
      if token.is_a? Hash
        token = OAuth2::AccessToken::from_hash(@oauth2client, token)
      elsif token.is_a? String
        if token =~ /^\s*{.+}\s*$/
          token_hash = MultiJson.decode(token)
          token = OAuth2::AccessToken::from_hash(@oauth2client, token)
        else
          token = { 'access_token' => token }
          token = OAuth2::AccessToken::from_hash(@oauth2client, token)
        end
      end

      unless token.is_a? OAuth2::AccessToken
        raise "Token is not a OAuth2::AccessToken"
      end

      @token = token

      @http = Faraday.new(url: api_version_url()) do |conn|
        conn.request :oauth2_refresh, @token
        conn.request :json
        if @instance_headers.is_a? Hash 
          @instance_headers.each do |k,v|
            conn.headers[k] = v
          end
        end
        conn.response :json, content_type: /\bjson$/
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    def api_version_url()
      return File.join API_HOST, API_VERSION
    end

    def authorize_uri(opts = {})
      @oauth2client = new_oauth2_client() unless @oauth2client
      opts.merge!({
        'client_id' => @client_id,
        'response_type' => 'code',
        'scope' => @scope })
      @oauth2client.auth_code.authorize_url _add_redirect_uri(opts)
    end

    def _add_redirect_uri(opts = {})
      if !opts.key?(:redirect_uri) && @oauth_redirect_uri.to_s.length > 0
        opts[:redirect_uri] = @oauth_redirect_uri.to_s
      end
      return opts
    end

    def authorize_code(code, opts = {})
      #token = @oauth2client.auth_code.get_token(code, _add_redirect_uri(opts))

      conn = Faraday.new(:url => API_HOST) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :json, content_type: /\bjson$/
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      params = {
        code: code,
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @oauth_redirect_uri,
        grant_type: 'authorization_code'
      }
      res = conn.post '/v1/tokens', params
      set_token res.body
      return @token
    end

    def new_oauth2_client()
      return OAuth2::Client.new(@client_id, @client_secret,
        site: OAUTH_HOST,
        authorize_url: OAUTH_AUTHZ_ENDPOINT,
        token_url: OAUTH_TOKEN_ENDPOINT)
    end

  end
end
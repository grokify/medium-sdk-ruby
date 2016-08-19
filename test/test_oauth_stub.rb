require './test/test_base.rb'

require 'faraday'

class MediumSdkOAuthStubTest < Test::Unit::TestCase
  def setup
    @string = 'deadbeef'
    @redirect_uri = 'https://example.com/callback'
    @sdk = MediumSdk.new client_id: 'dead', client_secret: 'beef', redirect_uri: @redirect_uri

    @body_token = JSON.parse('{
  "token_type": "Bearer",
  "access_token": "dead",
  "refresh_token": "beef",
  "scope": "listPublications",
  "expires_at": 12345
}')

    url = '/v1/tokens'
    #url = '/m/oauth/authorize'
    #url = 'tokens'
    #url = 'v1/tokens'

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post(url) { |env| [200, {}, @body_token] }
    end
    @client = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        stub.post(url) { |env| [ 200, {}, @body_token ]}
      end
    end
    stubs.post(url) { |env| [ 200, {}, @body_token ]}
    @sdk.connection.authcode_client = @client
  end

  def test_main
    token = @sdk.connection.authorize_code 'myTestAuthCode'
    assert_equal 12345, token.to_hash[:expires_at]
  end
end

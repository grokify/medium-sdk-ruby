require './test/test_base.rb'

require 'faraday'
require 'oauth2'

class MediumSdkSetupOAuthTest < Test::Unit::TestCase
  def setup
    @redirect_uri = 'https://example.com/callback'
    @sdk = MediumSdk.new client_id: 'dead', client_secret: 'beef', redirect_uri: @redirect_uri
  end

  def test_main
    assert_equal 'dead', @sdk.connection.client_id
    assert_equal @redirect_uri, @sdk.connection.oauth_redirect_uri
    assert_equal 'https://api.medium.com/v1', @sdk.connection.api_version_uri
  end
end

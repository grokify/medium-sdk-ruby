require './test/test_base.rb'

require 'faraday'
require 'oauth2'

class MediumSdkSetupTest < Test::Unit::TestCase
  def setup
    @token = 'deadbeef'
    @sdk = MediumSdk.new integration_token: @token
  end

  def test_main
    assert_equal 'deadbeef', @sdk.connection.token
  end
end

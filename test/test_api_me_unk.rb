require './test/test_base.rb'

require 'faraday'
require 'multi_json'

require 'pp'

class MediumSdkApiMeRaiseTest < Test::Unit::TestCase
  def setup
    @token = 'deadbeef'
    @sdk = MediumSdk.new integration_token: @token

    @sdk.connection.http = @client

  end
 
  def test_main
    assert_raise do
      @sdk.md_id
    end
  end
end

require './test/test_base.rb'

require 'faraday'
require 'multi_json'

class MediumSdkApiMeTest < Test::Unit::TestCase
  def setup
    @body = MultiJson.decode('{
  "data": {
    "id": "5303d74c64f66366f00cb9b2a94f3251bf5",
    "username": "majelbstoat",
    "name": "Jamie Talbot",
    "url": "https://medium.com/@majelbstoat",
    "imageUrl": "https://images.medium.com/0*fkfQiTzT7TlUGGyI.png"
  }
}')
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('me') { |env| [200, {}, @body] }
    end
    @client = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        stub.get('me') { |env| [ 200, {}, @body ]}
      end
    end

    @token = 'deadbeef'
    @sdk = MediumSdk.new integration_token: @token
    @sdk.connection.http = @client
  end

  def test_main
    data = @sdk.me
    assert_equal 'majelbstoat', data['username']
  end
end

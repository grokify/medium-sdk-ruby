require './test/test_base.rb'

require 'faraday'
require 'multi_json'

require 'pp'

class MediumSdkApiMeTest < Test::Unit::TestCase
  def setup
    body_me = MultiJson.decode('{
  "data": {
    "id": "5303d74c64f66366f00cb9b2a94f3251bf5",
    "username": "majelbstoat",
    "name": "Jamie Talbot",
    "url": "https://medium.com/@majelbstoat",
    "imageUrl": "https://images.medium.com/0*fkfQiTzT7TlUGGyI.png"
  }
}')
    body_user_publications = MultiJson.decode('{
  "data": [
    {
      "id": "b969ac62a46b",
      "name": "About Medium",
      "description": "What is this thing and how does it work?",
      "url": "https://medium.com/about",
      "imageUrl": "https://cdn-images-1.medium.com/fit/c/200/200/0*ae1jbP_od0W6EulE.jpeg"
    },
    {
      "id": "b45573563f5a",
      "name": "Developers",
      "description": "Medium’s Developer resources",
      "url": "https://medium.com/developers",
      "imageUrl": "https://cdn-images-1.medium.com/fit/c/200/200/1*ccokMT4VXmDDO1EoQQHkzg@2x.png"
    }
  ]
}')

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('me') { |env| [200, {}, body_me] }
      stub.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [200, {}, body_user_publications] }
    end
    @client = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        stub.get('me') { |env| [ 200, {}, body_me ]}
        stub.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [200, {}, body_user_publications] }
      end
    end

    stubs.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [ 200, {}, body_user_publications ]}

    @token = 'deadbeef'
    @sdk = MediumSdk.new integration_token: @token
    @sdk.connection.http = @client
  end

  def test_main
    data = @sdk.me
    assert_equal 'majelbstoat', data['username']
    id = '5303d74c64f66366f00cb9b2a94f3251bf5'
    assert_equal id, data['id']

    data2 = @sdk.user_publications
    assert_equal 'b969ac62a46b', data2[0]['id']

    data2 = @sdk.user_publications '5303d74c64f66366f00cb9b2a94f3251bf5'
    assert_equal 'b969ac62a46b', data2[0]['id']

  end
end

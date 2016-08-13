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
    body_publication_contributors = MultiJson.decode('{
  "data": [
    {
      "publicationId": "b45573563f5a",
      "userId": "13a06af8f81849c64dafbce822cbafbfab7ed7cecf82135bca946807ea351290d",
      "role": "editor"
    },
    {
      "publicationId": "b45573563f5a",
      "userId": "1c9c63b15b874d3e354340b7d7458d55e1dda0f6470074df1cc99608a372866ac",
      "role": "editor"
    },
    {
      "publicationId": "b45573563f5a",
      "userId": "1cc07499453463518b77d31650c0b53609dc973ad8ebd33690c7be9236e9384ad",
      "role": "editor"
    },
    {
      "publicationId": "b45573563f5a",
      "userId": "196f70942410555f4b3030debc4f199a0d5a0309a7b9df96c57b8ec6e4b5f11d7",
      "role": "writer"
    },
    {
      "publicationId": "b45573563f5a",
      "userId": "14d4a581f21ff537d245461b8ff2ae9b271b57d9554e25d863e3df6ef03ddd480",
      "role": "writer"
    }
  ]
}')

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('me') { |env| [200, {}, body_me] }
      stub.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [200, {}, body_user_publications] }
      stub.get('publications/b45573563f5a/contributors') { |env| [ 200, {}, body_publication_contributors ]}
    end
    @client = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        stub.get('me') { |env| [ 200, {}, body_me ]}
        stub.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [200, {}, body_user_publications] }
        stub.get('publications/b45573563f5a/contributors') { |env| [ 200, {}, body_publication_contributors ]}
      end
    end

    stubs.get('users/5303d74c64f66366f00cb9b2a94f3251bf5/publications') { |env| [ 200, {}, body_user_publications ]}
    stubs.get('publications/b45573563f5a/contributors') { |env| [ 200, {}, body_publication_contributors ]}

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

    data3 = @sdk.publication_contributors 'b45573563f5a'
    assert_equal '1c9c63b15b874d3e354340b7d7458d55e1dda0f6470074df1cc99608a372866ac', data3[1]['userId']
  end
end

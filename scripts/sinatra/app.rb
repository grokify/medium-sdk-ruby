#!ruby

require 'dotenv'
require 'medium_sdk'
require 'multi_json'
require 'pp'
require 'sinatra'

Dotenv.load

client = MediumSdk::Client.new(
  client_id: ENV['MEDIUM_CLIENT_ID'],
  client_secret: ENV['MEDIUM_CLIENT_SECRET'],
  redirect_uri: ENV['MEDIUM_OAUTH2_REDIRECT_URI'],
)

get '/' do
  pp client.connection.token
  token_json = client.connection.token.nil? \
    ? '' : MultiJson.encode(client.connection.token.to_hash, pretty: true)

  erb :index, locals: {
    authorize_uri: client.connection.authorize_uri(
      scope: 'basicProfile,publishPost',
      state: 'helloWorld'
    ),
    redirect_uri: client.connection.oauth_redirect_uri,
    token_json: token_json}
end

get '/callback/medium' do
  code = params.key?('code') ? params['code'] : ''
  puts 'CODE ' + code
  token = client.connection.authorize_code(code) #if code
  pp token.to_hash
  ''
end

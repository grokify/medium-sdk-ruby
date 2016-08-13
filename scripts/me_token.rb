#ruby

require 'dotenv'
require 'medium_sdk'
require 'pp'

Dotenv.load

token = ENV['MEDIUM_INTEGRATION_TOKEN']

client = MediumSdk.new integration_token: token

data = client.me

pp data

puts "DONE"

#!/usr/bin/env ruby

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV[ "CONS_TOKEN" ]
  config.consumer_secret     = ENV[ "SEC_CONS_TOKEN" ]
  config.access_token        = ENV[ "ACC_TOKEN" ]
  config.access_token_secret = ENV[ "SEC_ACC_TOKEN" ]
end


client.update("Ok should be good.")

#!/usr/bin/env ruby

require 'twitter'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV[ "CONS_TOKEN" ]
  config.consumer_secret     = ENV[ "SEC_CONS_TOKEN" ]
  config.access_token        = ENV[ "ACC_TOKEN" ]
  config.access_token_secret = ENV[ "SEC_ACC_TOKEN" ]
end

userName = "gardenZoneBot"

client.filter(track: userName) do |object|
  if object.is_a?(Twitter::Tweet)
    puts object.user.screen_name 
  end
end

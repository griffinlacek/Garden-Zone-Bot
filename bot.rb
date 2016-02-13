#!/usr/bin/env ruby

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV[ "CONS_TOKEN" ]
  config.consumer_secret     = ENV[ "SEC_CONS_TOKEN" ]
  config.access_token        = ENV[ "ACC_TOKEN" ]
  config.access_token_secret = ENV[ "SEC_ACC_TOKEN" ]
end

streaming_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV[ "CONS_TOKEN" ]
  config.consumer_secret     = ENV[ "SEC_CONS_TOKEN" ]
  config.access_token        = ENV[ "ACC_TOKEN" ]
  config.access_token_secret = ENV[ "SEC_ACC_TOKEN" ]
end

user_name = "gardenZoneBot"

streaming_client.filter(track: user_name) do |object|
  if object.is_a?(Twitter::Tweet)
    tweet_id  = object.id
    tweet_text = object.text
    reply_name = object.user.screen_name 
    
    zip_code = /\d{5}/.match(tweet_text)
    
    if !zip_code.nil?
       client.update("@#{reply_name} Your zip code is #{zip_code}", { in_reply_to_status_id: tweet_id })
    end
    
  end
end

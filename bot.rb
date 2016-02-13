#!/usr/bin/env ruby

require 'twitter'
require_relative "hardiness_zones"

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
    
    zone_info = get_zone(zip_code)
    
    if zip_code.nil?
      return_tweet = "I need a zip code!"
    elsif !zone_info.nil? 
      return_tweet = "The USDA hardiness zone for #{zone_info["city"]}, " +
      "#{zone_info["state"]} #{zone_info["line_zip"]} is : " +
      "#{zone_info["zone"]}"
      
      return_tweet = return_tweet.gsub(/\t/, '')
      
    else
      return_tweet = "That zip code is not in my database!"
    end

    client.update("@#{reply_name} #{return_tweet}", 
      { in_reply_to_status_id: tweet_id })

  end
end

#!/usr/bin/env ruby

require 'twitter'
require_relative "hardiness_zones"
require "pathname"

def get_state_map(state)
  state = state.downcase
  state_path = Pathname("state_maps/#{state}.jpg")
  
  map_file = File.new(state_path)
  
  return map_file
end

def tweet_update(client, reply_name, reply_tweet, tweet_id)
  #Check to not reply to self
  if(reply_name != "gardenzonebot") 
    client.update("@#{reply_name} #{reply_tweet}",
      in_reply_to_status_id: tweet_id )
  end
end

def tweet_media_update(client, reply_name, reply_tweet, tweet_id, media_id)
  #Check to not reply to self
  if(reply_name != "gardenzonebot") 
    client.update("@#{reply_name} #{reply_tweet}",
      in_reply_to_status_id: tweet_id, media_ids: media_id )
  end
end

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
      reply_tweet = "I need a zip code!"
      
      tweet_update(client, reply_name, reply_tweet, tweet_id)
    elsif !zone_info.nil? 
      reply_tweet = "The USDA hardiness zone for #{zone_info["city"]}, " +
      "#{zone_info["state"]} #{zone_info["line_zip"]} is : " +
      "#{zone_info["zone"]}"
      
      state_map = get_state_map(zone_info["state"])
    
      map_id = client.upload(state_map)
      
      tweet_media_update(client, reply_name, reply_tweet, tweet_id, map_id)

    else
      reply_tweet = "That zip code is not in my database!"
      
      tweet_update(client, reply_name, reply_tweet, tweet_id)
    end

  end
end
  
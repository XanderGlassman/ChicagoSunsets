
require "twitter"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
end

client.update_with_media("Sunset from " + File.ctime("sunset.jpg").strftime("%B %e, %Y at %I:%M%p"), File.new('sunset.jpg'))

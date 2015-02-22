require 'twitter'
require 'clockwork'
require 'solareventcalculator'

  def calculate_sunset
    @calc = 
      SolarEventCalculator.new(
        Date.today, BigDecimal.new("41.8600"), 
        BigDecimal.new("-87.6187")
      )
 
    @sunset = @calc.compute_official_sunset("America/Chicago")
    p @sunset
  end

  def tweet_pic 
    client = 
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
      end
    
    client.update_with_media("Sunset from " + File.ctime("sunset.jpg")
      .strftime("%B %e, %Y at %I:%M%p"), File.new('sunset.jpg'))
  end

module Clockwork

  calculate_sunset 

  handler do |job|
    case job 
    when 'take_pic'
      `raspistill -o sunset.jpg`
    when 'tweet_pic'
      tweet_pic
    when 'calculate sunset'
      calculate_sunset
    end
  end
  
  # every(10.seconds, 'sunset time')
  # # every(10.seconds, 'take_pic')
  every(1.day, 'calculate sunset', :at => '00:00')
  every(1.day, 'take_pic', :at => @sunset.strftime("%k:%M"))
  every(1.day, 'tweet_pic', :at => @sunset.strftime("%k:%M"))
end


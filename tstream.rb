require 'twitter'
require './secrets/secrets'

module Tstream
  def self.stream
    @stream ||= client = Twitter::Streaming::Client.new { |config| secrets(config) }
  end

  def follow_10(users = [23405982, 39564486])
    @tweets = []
    stream.filter(:follow => users.join(",")) do |object|
      @tweets << object# if object.is_a?(Twitter::Tweet)
      puts @tweets.size
      break if @tweets.size >= 10
    end
  end
  
  def self.track(topics = ["coffee", "tea"], n = 5)
    yweets = []
    stream.filter(:track => topics.join(",")) do |object|
      if object.is_a?(Twitter::Tweet)
        yweets << object 
        puts yweets.size
      break if yweets.size >= n
      end
    end
    yweets
  end

  def mentions(tweets)
    tweets.map do |x|
      [x.user.username, 
       x.entities? ? x.user_mentions.map(&:screen_name) : []]
    end
  end
end

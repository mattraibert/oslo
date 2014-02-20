require 'twitter'
require './secrets/secrets'

def client
  @@client ||= Twitter::REST::Client.new { |config| secrets(config) }
end

def stream
  @@stream ||= client = Twitter::Streaming::Client.new { |config| secrets(config) }
end

def filter(topics = ["coffee", "tea"])
  @tweets = []
  stream.filter(:track => topics.join(",")) do |object|
    @tweets << object# if object.is_a?(Twitter::Tweet)
    puts @tweets.size
    break if @tweets.size >= 10
  end
end

def mentions(tweets)
  tweets.map {|x| [x.user.username, x.user_mentions.map(&:screen_name)]}
end

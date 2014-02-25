require 'twitter'
require './secrets/secrets'

def stream
  @stream ||= client = Twitter::Streaming::Client.new { |config| secrets(config) }
end

def track_10(topics = ["coffee", "tea"])
  @tweets = []
  stream.filter(:track => topics.join(",")) do |object|
    if object.is_a?(Twitter::Tweet)
      @tweets << object 
      puts @tweets.size
      break if @tweets.size >= 10
    end
  end
end

def follow_10(users = [23405982, 39564486])
  @tweets = []
  stream.filter(:follow => users.join(",")) do |object|
    @tweets << object# if object.is_a?(Twitter::Tweet)
    puts @tweets.size
    break if @tweets.size >= 10
  end
end

def track(subjects = ["coffee", "tea"])
  stream.filter(:track => subjects.join(",")) do |object|
    if object.is_a?(Twitter::Tweet)
      puts object.user.username
      puts object.text
      puts ?* * 80
    end
  end
end

def mentions(tweets)
  tweets.map do |x|
    [x.user.username, 
     x.entities? ? x.user_mentions.map(&:screen_name) : []]
  end
end

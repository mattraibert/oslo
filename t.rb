require 'twitter'
require './secrets/secrets'

def client
  @client ||= Twitter::REST::Client.new { |config| secrets(config) }
end

def mentions(tweets)
  tweets.map do |x|
    [x.user.username, 
     x.entities? ? x.user_mentions.map(&:screen_name) : []]
  end
end

def friend_cursor(user)
  @friend_cursors ||= {}
  @friend_cursors[user.username] ||= client.friends(user.username)
end

def friend_objects(user)
  n = 10
  puts "#{n} friends of #{user.username}"
  friend_cursor(user).take(n)
end

def user_links(user)
  friend_objects(user).map {|u| {source: user.username, target: u.username, type: "follow"} }
end

def user_links2(user)
  friend_objects(user).map do |u|
    user_links(u)
  end.flatten
end

def write_json(data)
  File.write('foo.json', data.to_json)
end

def main
  write_json(user_links(client.user) + user_links2(client.user))
end

def main_json
  (user_links(client.user) + user_links2(client.user)).to_json
end

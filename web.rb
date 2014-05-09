require 'sinatra'
require './tstream'

set :bind, '0.0.0.0'

get '/main.json' do
  content_type :json
  Tstream::track.map {|t| {username: t.user.username, text: t.text }}.to_json
end

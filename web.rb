require 'sinatra'
require './t'

set :server, 'thin'
set :bind, '0.0.0.0'

get '/main.json' do
  content_type :json
  main_json
end

get '/main' do
  File.read('tweet_graph.html')
end

get '/graph.js' do
  content_type :js
  File.read('graph.js')
end

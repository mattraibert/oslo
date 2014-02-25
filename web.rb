require 'sinatra'
require './t'

get '/main.json' do
  content_type :json
  main_json
end

get '/main' do
  File.read('tweet_graph.html')
end

get '/graph.js' do
  File.read('graph.js')
end

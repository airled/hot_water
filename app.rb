require 'sinatra'
require './finder'
require 'json'

get '/' do
  erb :index
end

get '/data' do
  street = params[:street]
  house = params[:house]
  # content_type :json
  {date: find(street,house)}.to_json
end
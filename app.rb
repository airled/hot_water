require 'sinatra'
require './finder'
require 'json'

get '/' do
  erb :index
end

get '/date' do
  street = params[:street]
  house = params[:house]
  {date: date_find(street,house)}.to_json
end
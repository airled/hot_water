require 'sinatra'
require './finder'
require 'json'

get '/' do
  erb :index
end

get '/date' do
  street = params[:street].gsub('+',' ')
  house = params[:house]
  date = Finder.new.date_find(street,house)
  {date: date}.to_json
end
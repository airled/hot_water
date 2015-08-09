require 'sinatra'
require 'sinatra/base'
require './libs/finder'
require 'json'

class MyApp < Sinatra::Base

  get '/' do
    erb :index
  end

  get '/date' do
    if params.empty?
      'No params' 
    else
      street = params[:street]
      house = params[:house]
      house = house.split('-')[0] if house.include?('-')
      date = Finder.new.date_find(street,house)
      {date: date}.to_json
    end
  end

end #class
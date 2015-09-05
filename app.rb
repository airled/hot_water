require 'sinatra'
require 'sinatra/base'
require './lib/finder'
require 'json'
require 'haml'

class MyApp < Sinatra::Base

  get '/' do
    haml :index
    # erb :index
  end

  get '/date' do
    if params.empty?
      'No params' 
    else
      street = params[:street]
      house = params[:house]
      date = Finder.new.date_find(street,house)
      {date: date}.to_json
    end
  end

end #class

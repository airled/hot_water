require 'sinatra'
require 'sinatra/base'
require './lib/finder'
require 'json'
require 'haml'

class MyApp < Sinatra::Base

  get '/' do
    # haml :index
    erb :index
  end

  get '/date' do
    if (params.has_key?('street')) && (params.has_key?('house')) && (params[:street].match(/[^А-Яа-я0-9ё\.\ \-]/).nil?) && (params[:house].match(/[^А-Яа-яё0-9\.\ ]/).nil?)
      street = params[:street]
      house = params[:house]
      date = Finder.new.date_find(street,house)
      {date: date}.to_json
    else
      'Params error' 
    end
  end

end #class

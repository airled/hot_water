require 'sinatra'
require './lib/finder'
require 'json'

get '/' do
  erb :index
end

get '/date' do
  if (params.has_key?('street')) && (params.has_key?('house')) && (params[:street].match(/[^А-Яа-я0-9ё\.\ \-]/).nil?) && (params[:house].match(/[^А-Яа-яё0-9\.\ ]/).nil?)
    street = params[:street]
    house = params[:house]
    date = Finder.new.date_find(street, house)
    {date: date}.to_json
  else
    'Params error' 
  end
end

get '/auto_street' do
  term = params[:term]
  streets = Record.select(:street).distinct.where('street LIKE ?', "#{term}%").take(10)
  (streets.map { |street| {id: nil, label: street, value: street} }).to_json
end

require 'sinatra'
require './lib/finder'
require 'json'

HOST = 
  if settings.production?
    'http://hotwater.muzenza.by'
  end || 'http://localhost:9292'

get '/' do
  @host = HOST
  erb :index
end

get '/date' do
  if (params.size == 2) &&
     (params.has_key?('street')) && (params.has_key?('house')) &&
     (params[:street].match(/[^А-Яа-я0-9ё\.\ \-]/).nil?) && (params[:house].match(/[^А-Яа-яё0-9\.\ ]/).nil?)
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
  addresses = Address.distinct.select(:street).where('street LIKE ?', "#{term}%").limit(10)
  (addresses.map { |address| {id: nil, label: address.street, value: address.street} }).to_json
end

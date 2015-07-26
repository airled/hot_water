require 'sinatra'
require './finder'
require 'json'
require 'pry'


get '/' do
	erb :index, :format => :html5
end

get '/data' do
	street = params[:street]
	house = params[:house]
	p street
	p house
	# content_type :json
	puts({ date: find(street,house)}.to_json)

	{ date: find(street,house)}.to_json
end
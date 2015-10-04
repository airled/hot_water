require_relative './app'
require 'sprockets'

map '/public' do
  environment = Sprockets::Environment.new
  environment.append_path 'public/javascript'
  environment.append_path 'public/css'
  run environment
end

run Sinatra::Application

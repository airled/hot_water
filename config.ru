require_relative './app'
require 'sprockets'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'public/javascript'
  environment.append_path 'public/css'
  environment.append_path 'public/images'
  run environment
end

run Sinatra::Application

require_relative './app'
require 'sprockets'

map '/assets' do
  assets = Sprockets::Environment.new
  assets.append_path 'public/javascript'
  assets.append_path 'public/css'
  assets.append_path 'public'
  run assets
end

run Sinatra::Application

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Parse!'
task :parse do
  require_relative './lib/parser'
  DateParser.new.run
end

desc 'Full deploy'
task :deploy do
  system 'bundle exec mina stop'
  system 'bundle exec mina deploy'
  system 'bundle exec mina start'
end

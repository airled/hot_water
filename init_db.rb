require "yaml"
require "sequel"
require "mysql2"
# require "logger"


#connecting to a MySQL database
# hash = YAML.load_file("./config/database.yml")
DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :user => 'root', :database => 'hot_water')


# DB.loggers << Logger.new($stdout)
require 'sequel'
require 'mysql2'

DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :user => 'root', :database => 'hot_water')
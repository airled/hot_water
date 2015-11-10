require "yaml"
require "sequel"
require "mysql2"

#connecting to a MySQL database
DB = Sequel.connect(
  adapter: 'mysql2',
  host: 'localhost',
  user: 'root',
  database: 'hotwater'
)

require_relative './init_db'

class Date < Sequel::Model
  one_to_many :addresses
end

class Address < Sequel::Model
  many_to_one :dates
end
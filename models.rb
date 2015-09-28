require_relative './init_db'

class Offdate < Sequel::Model
  one_to_many :streets
end

class Street < Sequel::Model
  many_to_one :offdate
  one_to_many :houses
end

class House < Sequel::Model
  many_to_one :street
end

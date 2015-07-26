require './init_db'
require './models'

def find(street,house)
  binding.pry
  Record.filter(:street => street).each do |record| 
    if record.houses.include?(house)
      record.date
    else 
      nil
    end
  end
end

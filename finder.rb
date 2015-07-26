require './init_db'
require './models'

def find(street,house)
  Record.filter(:street => street).each do |record| 
    if record.houses.include?(house)
      return record.date
    else 
      return nil
    end
  end
end

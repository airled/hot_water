require './models'

def find(street,house)
  Record.filter(:street => street).each do |record|
  	return record.date if record.houses.include?(house)
  end
end

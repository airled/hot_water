require './init_db'
require './models'
require 'pry'

def find(street,house)
	binding.pry
	Record.filter(:street => street).each do |record| 
		if record.houses.include?(house)
			return record.date
		else 
			return nil
		end
	end

end

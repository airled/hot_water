require './models'

def date_find(street,house)
  result = Record[street: street, house: house]
  result.nil? ? 'No info' : result.date
end

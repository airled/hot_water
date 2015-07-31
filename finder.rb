require './models'

def date_find(street,house)
  result = Record[:street => street, :house => house]
  if result.nil?
    return 'No info' 
  else
    return result.date
  end
end

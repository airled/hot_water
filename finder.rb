require './models'

def find(street,house)
  result = nil
  Record.filter(:street => street).each do |record|
    if record.houses.include?(house)
      result = record.date
      break
    end
  end
  result ||= 'no info'
end

def find(street,house)
  result = Record.where{ (:street => street) & (:house => house)}.date
end

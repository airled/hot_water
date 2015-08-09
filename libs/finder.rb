require_relative '../models'

class Finder

  def date_find(street_raw,house_raw)
    street = street_standard(street_raw)
    house = house_standard(house_raw)
    result = if (!(Record[street: street].nil?) && Record[street: street].house == '*')
               Record[street: street].date
             elsif Record[street: street, house: house].nil?
               'Нет информации'
             else 
               Record[street: street, house: house].date
             end
    result
  end 

  private

  def street_standard(street)
    street.gsub('ё','е').sub(/улица|ул./,'').strip
  end

  def house_standard(house)
     house.include?('-') ? house.split('-')[0] : house
  end

end #class

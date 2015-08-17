require_relative '../models'

class Finder

  def date_find(street_raw,house_raw)
    street = normalized_street(street_raw)
    house = normalized_house(house_raw)
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

  def normalized_street(street)
    result = street.gsub('ё','е').sub(/улица|ул./,'').strip.split(' ')
    if result.size > 1
      return result.last
    else
      return result 
    end
  end

  def normalized_house(house)
     house.include?('-') ? house.split('-')[0] : house
  end

end #class

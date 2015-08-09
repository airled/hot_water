require_relative './models'

class Finder

  def date_find(street,house)
    result = if Record[street: street, house: house].nil?
               'Нет информации'
             elsif Record[street: street].house == '*'
               Record[street: street].date
             else 
               Record[street: street, house: house].date
             end
  result
  end

end #class

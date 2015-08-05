require_relative './models'

class Finder

  def date_find(street,house)
    result = if Record[street: street].house == '*'
              Record[street: street].date
             elsif Record[street: street, house: house].nil?
              'No info'
             else 
              Record[street: street, house: house].date
             end
  end

end

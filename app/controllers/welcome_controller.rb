class WelcomeController < ApplicationController
  def index
  end

  def get_data
    street = params[:street].gsub(/Улица|улица/, '').strip
    house = params[:house]

    if street.nil? || house.nil?
      render json: {date: 'no params'}
    else
      address = Address.find_by_street_and_house(street, house)
      if address
        render json: {date: address.offdate.date}
      else
        address_without_house = Address.where(street: street)
        if address_without_house.present? && address_without_house.count == 1 && address_without_house.first.house == "*"
          render json: {date: address_without_house.first.offdate.date}
        else
          render json: {date: "Нет информации"}
        end
      end
    end
  end

end

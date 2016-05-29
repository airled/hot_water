class WelcomeController < ApplicationController
  def index
  end

  def get_data
    street = params[:street].gsub(/Улица|улица/, '').strip.mb_chars.downcase.to_s
    house = params[:house]

    if street.nil? || house.nil?
      render json: {date: 'no params'}
    else
      address_full = Address.find_by_street_and_house(street, house)
      address_short = Address.find_by_street_and_house(street, house.gsub(/к[0-9]+/, ''))
      if address_full
        render json: {date: address_full.offdate.date}
      elsif address_short
        render json: {date: address_short.offdate.date}
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

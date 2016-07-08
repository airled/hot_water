class WelcomeController < ApplicationController
  def index
  end

  def get_data
    address = params[:address].gsub(/Улица|улица/, '').gsub(/пр-т/, 'проспект').strip.split(/ (?=[0-9])/)
    street = address[0]
    house = address[1]

    if street.blank? || house.blank?
      render json: {date: 'Неполный адрес'}
    else
      # address_full = Address.find_by_street_and_house(street, house)
      # address_short = Address.find_by_street_and_house(street, house.gsub(/к[0-9]+/, ''))
      address_full = Address.where(street: street.mb_chars.downcase.to_s.strip, house: house.mb_chars.downcase.to_s.strip).last
      address_short = Address.where(street: street.mb_chars.downcase.to_s.strip, house: house.mb_chars.downcase.to_s.gsub(/к[0-9]+/, '').strip).last
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

  def autocomplete_street
    return unless params[:term]
    street = params[:term].split(/ (?=[0-9])/)[0]
    house =  params[:term].split(/ (?=[0-9])/)[1]

    if house
      matches = Address.distinct.where("street like '#{street.strip.mb_chars.downcase.to_s}%'").where("house like '#{house.strip}%'").limit(10).map { |x| "#{x.street} #{x.house}" }
    else
      matches = Address.distinct.where("street like '#{street.strip.mb_chars.downcase.to_s}%'").limit(10).map { |x| "#{x.street} #{x.house}" }
    end

    render json: matches.uniq.to_json
  end

end

require_relative '../config/environment'

class DateParser

  URL = 'http://allbelarus.by/news/vodaotkl'

  def run
    DatabaseCleaner.clean_with(:truncation)
    html = fetch_html(URL)
    dates = html.xpath('//h3').drop(5)
    addresses_for_each_date = html.xpath('//p').drop(1)
    raise 'Dates and addresses has different amount of elements' if dates.size != addresses_for_each_date.size

    dates.zip(addresses_for_each_date).each do |date, addresses_for_date|
      offdate = Offdate.create(date: date.text.gsub(/[Сс:]/, '').strip)
      addresses_for_date = addresses_for_date.text.split(/[;\n]/) - ['']
      addresses_for_date = addresses_for_date.map { |x| x.gsub(/по генплану|д\/сад по г. п.|поликлиника|дом №[0-9]+|дома №[0-9]+|блок /, '') }
      addresses_for_date = addresses_for_date.map { |x| x.gsub(/пр-т/, 'проспект') }
      addresses_for_date = move_houses_to_previous_element(addresses_for_date)

      addresses_for_date.each do |street_with_its_houses|
        street = street_with_its_houses.split(',').first
        its_houses = street_with_its_houses.split(',').drop(1).map(&:strip)
        its_houses = ['*'] if its_houses.empty?
        its_houses.each do |house_or_houses|
          extend_range(house_or_houses).each do |house|
            offdate.addresses.create(street: street.strip, house: house)
          end
        end
      end

      Address.where(house: '').each(&:destroy)
    end

  end

  private

  def fetch_html(source)
    Nokogiri::HTML(Curl.get(source).body)
  end

  def move_houses_to_previous_element(addresses_for_date)
    addresses_for_date.each.with_index do |x, index|
      break if addresses_for_date[index].nil?
      if addresses_for_date[index].to_s.scan(/[А-Яа-я]{2,}/).empty?
        addresses_for_date[index - 1] = addresses_for_date[index - 1] + ', ' + addresses_for_date[index].to_s
        addresses_for_date.delete_at(index)
        redo
      end
    end
    addresses_for_date
  end

  def extend_range(range)
    if range.include?('—') && !(range.include?('к'))
      start = range.split('—')[0].to_i
      stop = range.split('—')[1].to_i
      if (stop - start).odd?
        (start..stop).to_a
      else
        (start..stop).step(2).to_a
      end
    else
      [range]
    end
  end

end #class

require_relative '../config/environment'

class DateParser

  URL = 'http://allbelarus.by/news/vodaotkl'

  def run
    html = fetch_html(URL)
    dates = html.xpath('//h3').drop(5)
    addresses_for_each_date = html.xpath('//p').drop(1)
    raise 'Dates and addresses has different amount of elements' if dates.size != addresses_for_each_date.size

    dates.zip(addresses_for_each_date).each do |date, addresses_for_date|
      p '---------------------------------------------------------------------'
      p date.text
      temp_array = addresses_for_date.text.split(/[;\n]/) - ['']

      temp_array.each.with_index do |x, index|
        break if temp_array[index].nil?
        if temp_array[index].to_s.scan(/[А-Яа-я]/).size < 3
          temp_array[index - 1] = temp_array[index - 1] + ', ' + temp_array[index].to_s
          temp_array.delete_at(index)
          redo
        end
      end

      temp_array.each do |x|
        p x.strip
      end
    end

  end

  private

  def fetch_html(source)
    Nokogiri::HTML(Curl.get(source).body)
  end

end #class

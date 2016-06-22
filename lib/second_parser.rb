require_relative '../config/environment'

class DateParser
  
  class << self

    URL = 'http://minsk.gov.by/ru/actual/view/625/'

    def run
      DatabaseCleaner.clean_with(:truncation)
      html = fetch_html(URL)
      dates = html.text.scan(/В +период +с +[0-9]+ +[А-Яа-я]+/)
      p dates
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

  end
end #class

DateParser.run

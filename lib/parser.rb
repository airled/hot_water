require_relative '../config/environment'

class DateParser

  URL = 'http://minsk.gov.by/ru/actual/view/625/'

  def run
    html = fetch_html(URL)
    html.xpath('//strong').select { |x| x.text.match(/[0-9]/) && x.text.match(/[А-Яа-я]/)}.map { |y| y.text.gsub(/В период(\ ){1,}| у потребителей по улицам|:/, '') }.each { |y| puts y }
  end

  private

  def fetch_html(source)
    Nokogiri::HTML(Curl.get(source).body)
  end

end #class

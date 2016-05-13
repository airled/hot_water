require 'nokogiri'
require 'curb'
require_relative '../models'

class Parser

  URL = 'http://minsk.gov.by/ru/actual/view/585/'

  def run
  end

  private

  def fetch_html(source)
    Nokogiri::HTML(Curl.get(source).body)
  end

end #class

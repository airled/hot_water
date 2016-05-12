require 'nokogiri'
require 'curb'
require_relative '../models'

class Parser

  URL = ''

  def run
  end

  private

  def fetch_html(source)
    Nokogiri::HTML(Curl.get(source).body)
  end

end #class

require 'nokogiri'
require 'open-uri'

html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))
html.xpath('//div[@class="main_block"]')
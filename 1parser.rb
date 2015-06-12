require 'nokogiri'
require 'open-uri'
require './models'

html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))

p_tags = html.xpath('//div[@class="main_block"]/p').map { |x| x.text }

puts p_tags
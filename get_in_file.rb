require 'nokogiri'
require 'open-uri'
require './models'

File.open('html.txt','w') {|file| file << Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh')) }
require 'nokogiri'
require 'open-uri'
require './models'

html = Nokogiri::HTML(open('html.txt'))
# html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))

div_inner = html.xpath('//div[@class="social"]').text.split("uptolike share en")[-1].strip

html.xpath('//div[@class="social"]').map(&:remove)
div_total = html.xpath('//div[@class="main_block"]').text.strip

text = (div_total + div_inner).gsub(" у потребителей по улицам:","%")

main = text.split(/В период /).drop(1)

file = File.open('temp.txt','w')

main.map do |block|
	splitted_block = block.split('%')
	file << {date: splitted_block[0], address: splitted_block[1]} << "\n"
end

file.close
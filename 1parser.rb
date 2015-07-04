require 'nokogiri'
require 'open-uri'
#require './models'

#fetching HTML
#html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))
html = Nokogiri::HTML(open('html.txt'))

#removing some unwanted tags  
html.xpath('//div[@class="social"]').map(&:remove)
html.xpath('//h2').map(&:remove)
# html.xpath('//div[@class="main_block"]//span').delete(html.xpath('//div[@class="main_block"]//span').last)

#collecting all text from main 'div' and removing some not-address stuff
text = html.xpath('//div[@class="main_block"]').text.strip
orgs = ['УП "Минсккоммунтеплосеть"','РУП "Минскэнерго"','филиал "Минские тепловые сети"']
orgs.map { |org| text.gsub!(org,"") }

file = File.open('temp.txt','w')

#dividing the text into the blocks by date
text.gsub!(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").gsub!(' у потребителей по улицам','%').strip
main = text.split(/В период/).drop(1)

#collecting dates and address groups into arrays
dates = []
groups = []
main.map do |date_with_group|
  dates << date_with_group.split('%')[0]
  groups << date_with_group.split('%')[1]
end

# groups.map do |part|
# 	file << part << "\n"
# end

html.xpath('//div[@class="main_block"]//strong').map do |tag|
	(file << tag.text << "\n") unless tag.text.include?('В период')
end

file.close

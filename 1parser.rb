require 'nokogiri'
require 'open-uri'
#require './models'

#html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))

html = Nokogiri::HTML(open('html.txt'))

html.xpath('//div[@class="social"]').map(&:remove)
html.xpath('//h2').map(&:remove)
# html.xpath("//span[][last()]").map(&:remove)

text = html.xpath('//div[@class="main_block"]').text.strip

orgs = ['УП "Минсккоммунтеплосеть"','РУП "Минскэнерго"','филиал "Минские тепловые сети"']
orgs.map { |org| text.gsub!(org,"") }

file = File.open('temp.txt','w')

text.gsub!(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").gsub!(' у потребителей по улицам','%').strip

main = text.split(/В период/).drop(1)

dates = []
groups = []

main.map do |date_with_group|
  dates << date_with_group.split('%')[0]
  groups << date_with_group.split('%')[1]
end

groups.map do |part|
	file << part << "\n"
end


file.close

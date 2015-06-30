require 'nokogiri'
require 'open-uri'
require './models'

html = Nokogiri::HTML(open('html.txt'))
# html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))
html.xpath('//h2').map(&:remove)
div_inner = html.xpath('//div[@class="social"]').text.split("uptolike share en")[-1].strip

html.xpath('//div[@class="social"]').map(&:remove)
div_total = html.xpath('//div[@class="main_block"]').text.strip

file = File.open('temp.txt','w')

text = (div_total + div_inner).gsub(" у потребителей по улицам:","%").gsub(/\n|\r/,"")
main = text.split(/В период /).drop(1)

dates = []
groups = []

main.map do |date_with_group|
  dates << date_with_group.split('%')[0]
  groups << date_with_group.split('%')[1].gsub(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"")
end

p dates.size
p groups.size

# combined = []

# dates.zip(groups).map do |date,group|
#   group.split(';').map do |block|    
#     block.split(/(\d)([А-Я][а-я])/).each_slice(2) do |slice|
#       combined << [date,slice.join]
#     end
#   end
# end

# combined.map {|x| file << x << "\n"}
# # combined.map {|x| Record.create(date: x[0], address: x[1])}

# combined.map do |record|
#   date = record[0]
#   splitted = record[1].split(/,/)
#   street = splitted[0]
#   houses = splitted - [street]
#   houses.map do |house|
#     Record.create(date: date, street: street, house: house)
#   end
# end

groups[0].scan(/\D+[А-Яа-я]\D+/).map do |x|
  file << x.gsub(/;/,"") << "\n"
end

file.close
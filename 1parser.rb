require 'nokogiri'
require 'open-uri'
require './models'

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

#fetching names of the streets from 'strong'-tags
streets = []
html.xpath('//div[@class="main_block"]//strong').map do |tag|
  tag.text.split(/,|;/).map do |street|
    streets << street unless street.include?('В период')
  end
end

file = File.open('temp.txt','w')

#preparing the text for dividing by groups
text.gsub!(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").gsub!(' у потребителей по улицам','%').strip
# streets.map do |street|
#   text.sub!(street,'!!')
# end

#dividing the text into the groups by date
main = text.split(/В период/).drop(1)

#collecting dates and address groups into arrays
dates = []
groups = []
main.map do |date_with_group|
  dates << date_with_group.split('%')[0]
  groups << date_with_group.split('%')[1]
end

separated_streets = []
groups.map do |group|
  array = []
  streets.map do |street|
    array << street if group.include?(street)
  end
  separated_streets << array
end

# dates.zip(groups).map do |date,group|
#   group.split(/!!/).map do |houses|
#     Record.create(date: date, house: houses)
#   end
# end

separated_streets.map do |blabla|
  file << blabla << "\n"
end

file.close

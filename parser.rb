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
    streets << street unless (street.include?('В период') || (((street.size < 5) && !(street[0] =~ /[а-я]/).nil?)) || street.size == 1)
  end
end

file = File.open('temp.txt','w')

#preparing the text for dividing by groups
text.gsub!(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").gsub!(' у потребителей по улицам','%').strip

#dividing the text into the groups by date
main = text.split(/В период/).drop(1)

#collecting dates and address groups into arrays
dates = []
groups = []
main.map do |date_with_group|
  dates << date_with_group.split('%')[0]
  groups << date_with_group.split('%')[1]
end

#separating streets-array by date
# separated_streets = []
# groups.drop(1).map do |group|
#   array = []
#   streets.map.with_index do |street,index|
#     if group.include?(street)
#       array << street
#       group.sub!(street,"!!!")
#       streets[index] = "@"
#     end
#   end
#   separated_streets << array
# end

dates.shift
groups.shift

# groups.map! do |group|
#   group.split(/!!!/)
# end

groups.map do |group|
  file << group << "\n"
end
# separated_streets.zip(groups).map do |streets,group|
#   streets.zip(group).map do |street,houses|
#     file << street + " - " + houses << "\n"
#   end
# end

file.close

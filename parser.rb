require 'nokogiri'
require 'open-uri'
require './models'

#fetching HTML and removing some unwanted tags  
def fetched_html(source)
  html = Nokogiri::HTML(open(source))
  html.xpath('//div[@class="social"]').map(&:remove)
  html.xpath('//h2').map(&:remove)
  # html.xpath('//div[@class="main_block"]//span').delete(html.xpath('//div[@class="main_block"]//span').last)
  html
end
  
#collecting all text from main 'div' and removing some non-address stuff
def fetched_text(html)
  raw_text = html.xpath('//div[@class="main_block"]').text
  ['УП "Минсккоммунтеплосеть"','РУП "Минскэнерго"','филиал "Минские тепловые сети"'].map { |org| raw_text.gsub!(org,"") }
  raw_text.gsub(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").strip
end
  
#fetching names of the streets from 'strong'-tags
def streets_from_strongs(html)
  streets = []
  html.xpath('//div[@class="main_block"]//strong').map do |tag|
    tag.text.split(/[,;]/).map do |street|
      streets << street unless (street.include?('В период') || (((street.size < 5) && !(street[0] =~ /[а-я]/).nil?)) || street.size == 1)
    end
  end
  streets
end

file = File.open('temp.txt','w')

# source = 'http://www.belta.by/ru/dose_menu/grafik_zkh'
source = 'html.txt'
html = fetched_html(source)
streets = streets_from_strongs(html)

#dividing the text into the groups by date
main = fetched_text(html).split('В период').drop(1)

#collecting dates and address groups into arrays
dates = []
groups = []
main.map do |date_with_group|
  dates << date_with_group.split(' у потребителей по улицам')[0]
  groups << date_with_group.split(' у потребителей по улицам')[1]
end

#temporary code for removing some non-<strong> names
dates.shift
groups.shift

#separating streets-array by date and replacing names of the streets in address groups for further splitting
streets_blocks = []
groups.map do |group|
  matched_streets = []
  streets.map.with_index do |street,index|
    if group.include?(street)
      matched_streets << street
      group.sub!(street,'!!!')
      streets[index] = '@'
    end
  end
  streets_blocks << matched_streets
end

#splitting groups by name of the streets from <strong>'s
houses_blocks = groups.map { |group| group.gsub(';',',').split('!!!').drop(1) }

dates.zip(streets_blocks,houses_blocks).map do |date,streets_block,houses_block|
  file << date << "\n" << "\n"
  streets_block.zip(houses_block).map do |street,houses|
    case
    when houses.scan(/[0-9А-Яа-я]/).empty?
      houses = ''
    when houses[0] == ','
      houses[0] = ' '
    end
    houses.gsub!(/ – /,"-")
    houses.strip!
    houses.gsub!(/[^0-9А-Яа-я()\ ][^0-9А-Яа-я()\ ]/, '')
    file << street + ' ||| ' + houses << "\n"
    # Record.create(date: date, street: street, houses: houses)
  end
  file << "\n"
end

# file.close

# a = "1,2,3,4-6,7,8,9-11"
# expanded =[]
# a.split(/,/).map.with_index do |x,index|
#     if x =~ /[0-9]+-[0-9]+/
#         start = x.split(/-/)[0]
#         stop = x.split(/-/)[1]
#         start.upto(stop) do |y|
#             expanded << y
#         end
#     elsif expanded << x
#     end
# end

# expanded.join(',')


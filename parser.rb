require 'nokogiri'
require 'open-uri'
require './models'

file = File.open('temp.txt','w')

#fetching HTML
#html = Nokogiri::HTML(open('http://www.belta.by/ru/dose_menu/grafik_zkh'))
html = Nokogiri::HTML(open('html.txt'))

#removing some unwanted tags  
html.xpath('//div[@class="social"]').map(&:remove)
html.xpath('//h2').map(&:remove)
# html.xpath('//div[@class="main_block"]//span').delete(html.xpath('//div[@class="main_block"]//span').last)

#collecting all text from main 'div' and removing some non-address stuff
text = html.xpath('//div[@class="main_block"]').text.strip
orgs = ['УП "Минсккоммунтеплосеть"','РУП "Минскэнерго"','филиал "Минские тепловые сети"']
orgs.map { |org| text.gsub!(org,"") }

#fetching names of the streets from 'strong'-tags
streets = []
html.xpath('//div[@class="main_block"]//strong').map do |tag|
  tag.text.split(/[,;]/).map do |street|
    streets << street unless (street.include?('В период') || (((street.size < 5) && !(street[0] =~ /[а-я]/).nil?)) || street.size == 1)
  end
end

#preparing the text for dividing by date groups
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

#separating streets-array by date and replacing names of the streets in address groups for further splitting
separated_streets = []
groups.drop(1).map do |group|
  array = []
  streets.map.with_index do |street,index|
    if group.include?(street)
      array << street
      group.sub!(street,'!!!')
      streets[index] = '@'
    end
  end
  separated_streets << array
end

dates.shift
groups.shift

#splitting groups by name of the streets from <strong>'s
groups.map! { |group| group.split(/!!!/).drop(1) }

dates.zip(separated_streets,groups).map do |date,streets,group|
  streets.zip(group) do |street,houses|
    houses.gsub!(/ – /,"-")
    case
    when houses.scan(/[0-9А-Яа-я]/).empty?
      houses = ''
    when houses[0] == ','
      houses[0] = ' '
    end
    houses.strip!
    file << street + ' ||| ' + houses << "\n"
    # Record.create(date: date, street: street, houses: houses)
  end
end

file.close

# a = "1,3,6,32,4,6,3-56,234,457,234,34-657"
# a_expanded =[]
# a.split(/,/).map do |x|
#     if x
#     start = x.split(/-/)[0]
#     stop = x.split(/-/)[1]

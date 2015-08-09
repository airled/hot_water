require 'nokogiri'
require 'open-uri'
require_relative '../models'

class Parser

  #fetching HTML from source URL and removing some unwanted tags from it
  def fetch_html(source)
    html = Nokogiri::HTML(open(source))
    html.xpath('//div[@class="social"]').map(&:remove)
    html.xpath('//h2').map(&:remove)
    html
  end
    
  #collecting all text from main 'div' and removing some non-address stuff
  def fetch_text(html)
    raw_text = html.xpath('//div[@class="main_block"]').text
    ['УП "Минсккоммунтеплосеть"','РУП "Минскэнерго"','филиал "Минские тепловые сети"'].map { |org| raw_text.gsub!(org,"") }
    raw_text.gsub(/[^\ 0-9.,А-Яа-я;\/\-()–№\"]/,"").strip
  end
    
  #fetching street's names from <strong>'s and putting it in the array
  def streets_from_strongs(html)
    streets = []
    html.xpath('//div[@class="main_block"]//strong').map do |tag|
      tag.text.split(/[,;]/).map do |street|
        streets << street unless (street.include?('В период') || (((street.size < 5) && !(street[0] =~ /[а-я]/).nil?)) || street.size == 1)
      end
    end
    streets
  end

  #fetching ranges (like '12-20') and extending it in a sequence of values (array)
  def extended(range)
    sequence = []
    unless range.include?('к')
      start = range.split('-')[0].to_i
      stop = range.split('-')[1].to_i
      case
      when start.even? && stop.even?
        start.upto(stop) { |value| sequence << value.to_s if value.even? }
      when start.odd? && stop.odd?
        start.upto(stop) { |value| sequence << value.to_s if value.odd? }
      when (start.odd? && stop.even?) || (start.even? && stop.odd?)
        start.upto(stop) { |value| sequence << value.to_s }
      end
    else sequence << range
    end
    sequence
  end

  def run
    puts 'Begin parsing...'
    amount_start = Record.count
    file = File.open('temp.txt','w')
    file1 = File.open('temp1.txt','w')

    # source = 'http://www.belta.by/regions/view/grafik-otkljuchenija-gorjachej-vody-v-minske-v-2015-godu-153269-2015/'
    source = 'html.txt'
    html = fetch_html(source)
    streets = streets_from_strongs(html)

    #dividing the text into the parts by date (each part includes information about date and adresses unsplitted)
    main = fetch_text(html).split('В период').drop(1)

    #splitting each element of main array by keywords into date part and addresses groups part (one group matches one date) 
    dates = []
    groups = []
    main.map do |date_with_group|
      dates << date_with_group.split(' у потребителей по улицам')[0].strip
      groups << date_with_group.split(' у потребителей по улицам')[1].strip
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
      file1 << date << "\n" << "\n"
      streets_block.zip(houses_block).map do |street,houses|
        case
        when houses.scan(/[0-9А-Яа-я]/).empty?
          houses = '*'
        when houses[0] == ','
          houses[0] = ' '
        end
        houses = houses.gsub(' – ','-').strip.gsub(/[^0-9А-Яа-я*()\ ][^0-9А-Яа-я*()\ ]/, '')
        file << street + ' ||| ' + houses << "\n"

        houses.split(/,/).map do |houses_part|
          if houses_part =~ /[0-9]+-[0-9]+/
            extended(houses_part).map do |house|
              file1 << street + ' ||| ' + house.strip << "\n"
              Record.create(date: date, street: street, house: house.strip)
            end
          else 
            file1 << street + ' ||| ' + houses_part.strip << "\n"
            Record.create(date: date, street: street, house: houses_part.strip)
          end
        end
        file1 << "\n"
      end
      file << "\n"
    end

    file.close
    file1.close
    amount_stop = Record.count
    puts "Parsed. Records created: #{amount_stop - amount_start}"
  end #def run
  
end #class

Parser.new.run
require 'nokogiri'
require 'open-uri'
require_relative '../models'

class Parser

  def run
    puts 'Begin parsing...'
    amount_start = Record.count
    source = 'http://www.belta.by/regions/view/grafik-otkljuchenija-gorjachej-vody-v-minske-v-2015-godu-153269-2015/'
    html = fetch_html(source)
    p_tags_into_file(html)
    second_part
    streets_strong = streets_from_strongs(html)
    first_part(html,streets_strong)
    amount_stop = Record.count
    puts "Parsed. Records created: #{amount_stop - amount_start}"
  end

  private

  def fetch_html(source)
    Nokogiri::HTML(open(source))
  end

  def p_tags_into_file(html)
    file = File.open('temp.txt','w')
    html.xpath('//div[@class="center_col"]/p').map do |p_tag|
      (file << p_tag.text.gsub(/у потребителей по улицам:|;/,'').gsub('в период','В период').strip << "\n") unless p_tag.text.match(/[А-Яа-я]/).nil?
    end
    file.close
  end

  def second_part
    hashes = []
    date = ''
    file = File.open('temp.txt','r')
    file.each do |line|
      if line.include?('В период')
        date = line.gsub(/[^А-Яа-я0-9\ ]|В период /,'')
        next
      else
        hashes << {date: date, date_match: line.strip}
      end
    end
    file.close
    hashes.delete_at(0)
    hashes.delete_at(0)
    hashes.delete_at(0)
    hashes.map do |hash|
      splitted_line = hash[:date_match].split(',')
      street = splitted_line[0]
      splitted_line.drop(1).map do |houses|
        extended(houses).map do |house|
          Record.create(date: hash[:date], street: street, house: house.strip)
        end
      end
    end
  end
  
  def streets_from_strongs(html)
    streets = []
    html.xpath('//div[@class="center_col"]//strong').map do |strong|
      streets << strong.text unless (strong.text.include?('В период') || strong.text.include?('в период') || strong.text == '')
    end
    streets
  end

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

  def first_part(html,streets)
    divider = 'График отключения горячей воды в Минске на август будет доступен после 15 июля.'
    first_part_text = html.xpath('//div[@class="center_col"]').text.strip.split(divider)[0]
    #main => [ date_with_address_group1, date_with_address_group2... ]
    main = first_part_text.split('В период').drop(1)

    dates = []
    date_blocks = []

    main.map do |date_part|
      dates << date_part.split(' у потребителей по улицам')[0].strip
      date_blocks << date_part.split(' у потребителей по улицам')[1].strip
    end
    #streets_blocks => [ (block for date1)->[street1,street2,street3], (block for date2)->[street4,street5,street6]... ]
    streets_blocks = []
    date_blocks.map do |date_block|
      matched_streets = []
      streets.map.with_index do |street,index|
        if date_block.include?(street)
          matched_streets << street
          date_block.sub!(street,'!!!')
          streets[index] = '@'
        end
      end
      streets_blocks << matched_streets
    end
    #houses_blocks => [ (for date1)->[houses_for street1,houses_for street2,houses_for street3], (for date2)->[houses_for_street4, houses_for_street5,houses_for street6]... ]
    houses_blocks = date_blocks.map { |date_block| date_block.gsub(';',',').split('!!!').drop(1) }

    dates.zip(streets_blocks,houses_blocks).map do |date,streets_block,houses_block|
      streets_block.zip(houses_block).map do |street,houses|
        case
        when houses.scan(/[0-9А-Яа-я]/).empty?
          houses = '*'
        when houses[0] == ','
          houses[0] = ' '
        end
        houses = houses.gsub(' – ','-').strip.gsub(/[^0-9А-Яа-я*()\ ][^0-9А-Яа-я*()\ ]/, '')
        houses.split(',').map do |houses_part|
          if houses_part =~ /[0-9]+-[0-9]+/
            extended(houses_part).map do |house|
              Record.create(date: date, street: street, house: house.strip)
            end
          else 
            Record.create(date: date, street: street, house: houses_part.strip)
          end
        end
      end
    end
  end

end #class

Parser.new.run
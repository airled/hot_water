require 'nokogiri'
require 'open-uri'
require_relative '../models'

class Parser

  def run
    puts 'Begin parsing...'
    source = 'http://www.belta.by/regions/view/grafik-otkljuchenija-gorjachej-vody-v-minske-v-2015-godu-153269-2015/'
    html = fetch_html(source)
    p_tags_into_file(html)
    hash_in_file(main_hash)
  end

  private

  def fetch_html(source)
    Nokogiri::HTML(open(source))
    # html = Nokogiri::HTML(open(source))
  end

  def p_tags_into_file(html)
    file = File.open('../temp.txt','w')
    html.xpath('//div[@class="center_col"]/p').map do |p_tag|
      (file << p_tag.text.gsub('у потребителей по улицам:','').gsub('в период','В период').strip << "\n") unless p_tag.text.match(/[А-Яа-я]/).nil?
    end
    file.close
  end

  def main_hash
    main_hash = []
    date = ''
    file = File.open('../temp.txt','r')
    file.each do |line|
      if line.include?('В период')
        date = line.gsub(/[^А-Яа-я0-9\ ]|В период /,'')
        # date = line.gsub(/[^А-Яа-я0-9\ ]/,'').gsub('В период ','')
        next
      else
        main_hash << {date: date, date_match: line.strip}
      end
    end
    file.close
    main_hash.delete_at(0)
    main_hash.delete_at(0)
    main_hash.delete_at(0)
    main_hash
  end

  def hash_in_file(hash)
    file = File.open('../temp1.txt','w')
    hash.map { |element| file << element << "\n" }
  end
  
end #class

Parser.new.run
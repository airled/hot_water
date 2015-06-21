require 'nokogiri'
require 'open-uri'
require './models'

# html = Nokogiri::HTML(open('http://allbelarus.by/news/vodaotkl'))
html = Nokogiri::HTML(open('temp.txt'))

h3_tags = html.xpath('//div[@class="content clear-block"]/h3').map { |date| date.text.delete(':').sub('С ','').strip if date.text.include?(':') }
p_tags = html.xpath('//div[@class="content clear-block"]/p').map { |element| element.text.sub('по улицам', '').strip}

dates = h3_tags.compact
blocks = p_tags.drop(1)

dates.zip(blocks).map do |date,block_for_date|
  temp = []
  splitted_block_for_date = block_for_date.split(/; ([А-Я])|; ([1-9]\-[а-я])/)
  first = splitted_block_for_date[0]
  splitted_block_for_date.drop(1).each_slice(2) { |slice| temp << slice.join }
  temp << first
  temp.map { |address| Record.create(:date => date, :address => address) }
end
require 'nokogiri'
require 'open-uri'
require './models'

html = Nokogiri::HTML(open('http://allbelarus.by/news/vodaotkl'))

h3_tags = html.xpath('//div[@class="content clear-block"]/h3').map { |date| date.text.include?(':') ? date.text.delete(':').sub('С ','') : ' '}
p_tags = html.xpath('//div[@class="content clear-block"]/p').map { |element| element.text.sub('по улицам', '').strip}

dates = h3_tags.reject { |x| x == ' ' }
blocks = p_tags.drop(1)

dates.zip(blocks).map do |date,block|
  splitted_block = block.split('; ')
  splitted_block.map do |address|
    Record.create(:date => date, :address => address)
  end
end

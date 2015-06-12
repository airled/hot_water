require 'nokogiri'
require 'open-uri'

html = Nokogiri::HTML(open('http://allbelarus.by/news/vodaotkl'))

h3_tags = html.xpath('//div[@class="content clear-block"]/h3').map { |date| date.text.include?(':') ? date.text.delete(':') : ' '}
p_tags = html.xpath('//div[@class="content clear-block"]/p').map { |element| element.text.gsub('по улицам', '').strip}

dates = h3_tags.reject { |x| x == ' ' }
blocks = p_tags.drop(1)

streets_of_date = blocks.map { |block| block.split('; ') }
streets_groups = streets_of_date.map do |x|
	x.map { |y| y.split('",') }
end

hashes = dates.map do |date|
	streets_groups.map do |street_group|
		street_group.map do |street|
			{:date => date, :street => street}
		end
	end
end

p hashes
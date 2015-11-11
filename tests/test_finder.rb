require_relative './helper.rb'
require_relative '../lib/finder.rb'

class TestFinder < Minitest::Test
	
  def setup
    @finder = Finder.new
  end

  def test_that_date_find
  	existing = {street: 'Тарханова', house: '15'}
  	nonexisting = {street: 'Блабла', house: 'Мимими'}
  	assert_equal 'с 27 июля', @finder.date_find(existing[:street], existing[:house])
  	assert_equal 'Нет информации', @finder.date_find(nonexisting[:street], nonexisting[:house])
  end
  
end

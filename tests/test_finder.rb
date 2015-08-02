require 'minitest/autorun'
require_relative '../finder.rb'

class TestFinder < Minitest::Unit::TestCase
	
  def setup
    @finder = Finder.new
  end

  def test_that_date_find
  	correct = {street: 'Гинтовта', house: '36'}
  	incorrect = {street: 'Блабла', house: 'Мимими'}
  	assert_equal 'с 6 июля', @finder.date_find(correct[:street],correct[:house])
  	assert_equal 'No info', @finder.date_find(incorrect[:street],incorrect[:house])
  end

end
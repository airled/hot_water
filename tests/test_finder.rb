require 'minitest/autorun'
require_relative '../finder.rb'

class TestFinder < Minitest::Test
	
  def setup
    @finder = Finder.new
  end

  def test_that_date_find
  	existing = {street: 'Гинтовта', house: '36'}
  	nonexisting = {street: 'Блабла', house: 'Мимими'}
  	assert_equal 'с 6 июля', @finder.date_find(existing[:street],existing[:house])
  	assert_equal 'No info', @finder.date_find(nonexisting[:street],nonexisting[:house])
  end
end
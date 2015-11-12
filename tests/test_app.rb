require_relative './helper.rb'
require_relative '../app.rb'

class TestApp < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root_path
    get '/'
    assert last_response.ok?
  end

  def test_date_path
    get '/date'
    assert last_response.ok?
    assert_equal 'Params error', last_response.body    
    get '/date?street=test'
    assert last_response.ok?
    assert_equal 'Params error', last_response.body    
    get '/date?house=test'
    assert last_response.ok?
    assert_equal 'Params error', last_response.body    
    get '/date?street=test&house=test'
    assert last_response.ok?
    assert_equal 'Params error', last_response.body
  end

end

ENV['RACK_ENV'] = 'test'
require_relative('../config/environment')
require 'minitest/autorun'
require 'rack/test'

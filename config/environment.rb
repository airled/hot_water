require 'yaml'

class ENV_adder

  def self.add_from_yaml
    rack_env = ENV['RACK_ENV'] ||= 'development'
    hash = YAML.load_file("./config/environments/#{rack_env}.yml")
    hash.each_pair { |pair| ENV["#{pair[0]}"] = pair[1] }
  end

end

ENV_adder.add_from_yaml

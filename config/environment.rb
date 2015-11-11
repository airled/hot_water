require 'yaml'

class ENV_adder

  def self.add_from_yaml
    rack_env = ENV['RACK_ENV'] ||= 'development'
    env_hash = YAML.load_file(File.expand_path("../environments/#{rack_env}.yml", __FILE__))
    env_hash.each_pair { |pair| ENV["#{pair[0]}"] = pair[1] }
  end

end

ENV_adder.add_from_yaml

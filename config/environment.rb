require 'yaml'

#adding all the parameters from the environment's yaml to ENV
class ENV_adder

  def self.add_from_yaml
    ENV['RACK_ENV'] ||= 'development'
    env_hash = YAML.load_file(File.expand_path("../environments/#{ENV['RACK_ENV']}.yml", __FILE__))
    env_hash.each_pair { |key, value| ENV[key] = value.to_s }
  end

end

ENV_adder.add_from_yaml

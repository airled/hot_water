SOURCE_SERVER = 
  case ENV['RACK_ENV']
  when 'production', 'deployment'
    'http://hotwater.muzenza.by'
  when 'development', 'test'
    'http://localhost:9292'
  end

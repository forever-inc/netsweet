require 'pry'
require 'securerandom'
require 'rspec'
require 'rspec/given'

# require all support files
Dir['./spec/support/**/*.rb'].each { |f| require f }

# generate log directory for revolution gem
log_directory = Pathname.new(Netsweet.config.revolution_prep_log_path).dirname
Dir.mkdir(log_directory) unless Dir.exists?(log_directory)

RSpec.configure do |c|
  c.mock_with :rspec
end

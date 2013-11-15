require 'pry'
require 'securerandom'
require 'rspec'
require 'rspec/given'

# require all support files
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec
end

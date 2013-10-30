require 'dotenv'

environment = 'test'
env_path = Pathname.new(".env.#{environment}")

if env_path.exist?
  Dotenv.load(env_path)
else
  raise ArgumentError.new("Must provide a .env.#{environment} file to configure Netsweet!") unless env_path.exist?
end

require 'netsweet'
load 'config/netsweet.rb'

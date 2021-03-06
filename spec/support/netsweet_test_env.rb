require 'dotenv'

environment = 'test'
env_path = Pathname.new(".env.#{environment}")

if env_path.exist?
  Dotenv.load(env_path)
else
  raise ArgumentError, "Must provide a .env.#{environment} file to configure Netsweet!"
end

require 'netsweet'
load 'config/netsweet.rb'

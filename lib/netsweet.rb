require 'netsweet/version'
require 'netsuite'
require 'netsuite-rest-client'

module Netsweet

  autoload :Config, 'netsweet/config.rb'
  autoload :Product, 'netsweet/product.rb'
  autoload :Connection, 'netsweet/connection.rb'
  autoload :Client, 'netsweet/client.rb'
  autoload :Customer, 'netsweet/customer.rb'
  autoload :SSO, 'netsweet/sso.rb'

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield config
  end
end

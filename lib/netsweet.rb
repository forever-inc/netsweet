require 'netsweet/version'
require 'netsuite'
require 'netsuite-rest-client'
require_relative 'netsweet/gen/soap_proxy/defaultDriver'

module Netsweet

  autoload :Config, 'netsweet/config.rb'
  autoload :Product, 'netsweet/product.rb'
  autoload :Connection, 'netsweet/connection.rb'
  autoload :Client, 'netsweet/client.rb'
  autoload :Customer, 'netsweet/customer.rb'
  autoload :SSO, 'netsweet/sso.rb'

  # errors
  autoload :CustomerNotFound, 'netsweet/errors.rb'
  autoload :MapSSOFailed, 'netsweet/errors.rb'

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield config

    require_relative '../config/revolution_prep'
  end
end

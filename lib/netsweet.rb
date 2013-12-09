require 'netsweet/version'
require 'netsuite'
require 'netsuite-rest-client'
require_relative 'netsweet/gen/soap_proxy/defaultDriver'

module Netsweet
  autoload :Util,                     'netsweet/util.rb'
  autoload :Translator,               'netsweet/translator.rb'
  autoload :Config,                   'netsweet/config.rb'
  autoload :Connection,               'netsweet/connection.rb'
  autoload :Client,                   'netsweet/client.rb'
  autoload :SSO,                      'netsweet/sso.rb'
  autoload :Product,                  'netsweet/product.rb'
  autoload :Customer,                 'netsweet/customer.rb'
  autoload :CustomerNotFound,         'netsweet/errors.rb'
  autoload :MapSSOFailed,             'netsweet/errors.rb'
  autoload :ConfigurationError,       'netsweet/errors.rb'
  autoload :CustomerNotCreated,       'netsweet/errors.rb'
  autoload :CustomerEmailNotUnique,   'netsweet/errors.rb'
  autoload :MultipleCustomersCreated, 'netsweet/errors.rb'
  autoload :ConnectionError,          'netsweet/errors.rb'
  autoload :ClientError,              'netsweet/errors.rb'

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield config
    config.validate_configuration!

    require_relative '../config/revolution_prep'
    require_relative '../spec/mocks/mocks.rb' if config.mock_mode
  end
end

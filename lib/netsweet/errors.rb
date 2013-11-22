# Encoding: utf-8

module Netsweet
  CustomerNotFound       = Class.new(Exception)
  MapSSOFailed           = Class.new(Exception)
  ConfigurationError     = Class.new(Exception)
  CustomerNotCreated     = Class.new(Exception)
  CustomerEmailNotUnique = Class.new(Exception)
end

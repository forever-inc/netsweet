module Netsweet
  CustomerNotFound         = Class.new(Exception)
  MapSSOFailed             = Class.new(Exception)
  ConfigurationError       = Class.new(Exception)
  CustomerNotCreated       = Class.new(Exception)
  CustomerNotUnique        = Class.new(Exception)
  MultipleCustomersCreated = Class.new(Exception)
  RecordNotFound           = Class.new(Exception)
  ConnectionError          = Class.new(Exception)
  ClientError              = Class.new(Exception)
end

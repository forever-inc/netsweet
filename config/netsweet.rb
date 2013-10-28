Netsweet.configure do |config|

  config.sandbox     = ENV['SANDBOX']
  config.api_version = ENV['API_VERSION']

  # may be a alphanumeric id
  config.company = ENV['ECID']
  config.partner = ENV['PID']
  config.account = ENV['ACCOUNT']

  # system user used by the webservice
  config.rest_username = ENV['REST_USERID']
  config.rest_password = URI.escape(ENV['REST_PASSWORD'])
  config.soap_username = ENV['SOAP_USERID']
  config.soap_password = URI.escape(ENV['SOAP_PASSWORD'])
  config.role          = ENV['ROLE']

  config.host     = ENV['HOST']
  config.wsdl_url = ENV['WSDL_HOST'] + "/wsdl/v#{config.api_version}_0/netsuite.wsdl"

  config.private_key_path       = Pathname.new(ENV['PRIVATE_KEY_PATH'])
  config.private_key_passphrase = ENV['PRIVATE_KEY_PASSPHRASE']

  config.revolution_prep_log_path = ENV['REVOLUTION_PREP_LOG_PATH']

end

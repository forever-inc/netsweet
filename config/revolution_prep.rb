# RevolutionPrep Gem Configuration
NetSuite.configure do
  reset!

  api_version Netsweet.config.api_version
  wsdl        Netsweet.config.wsdl_url
  account     Netsweet.config.account
  email       Netsweet.config.soap_username
  password    Netsweet.config.soap_password
  role        Netsweet.config.role

  # or specify the sandbox flag if you don't want to deal with specifying a full URL
  sandbox false

  # often the netsuite servers will hang which would cause a timeout exception to be raised
  # if you don't mind waiting (e.g. processing NS via DJ), increasing the timeout should fix the issue
  read_timeout 100000

  # you can specify a file or file descriptor to send the log output to (defaults to STDOUT)
  log Netsweet.config.revolution_prep_log_path

end

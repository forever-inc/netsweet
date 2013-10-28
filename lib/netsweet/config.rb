module Netsweet
  class Config

    OPTIONS = [
      :account,
      :api_version,
      :company,
      :netsuite_host,
      :partner,
      :private_key_passphrase,
      :private_key_path,
      :rest_password,
      :rest_username,
      :role,
      :sandbox,
      :soap_password,
      :soap_username,
      :wsdl_url
    ]

    attr_accessor *OPTIONS

  end
end

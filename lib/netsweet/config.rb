module Netsweet
  class Config

    OPTIONS = [
      :account,
      :api_version,
      :company,
      :host,
      :partner,
      :private_key_passphrase,
      :private_key_path,
      :rest_password,
      :rest_username,
      :revolution_prep_log_path,
      :role,
      :sandbox,
      :soap_password,
      :soap_username,
      :sso_endpoint_url,
      :wsdl_url
    ]

    attr_accessor *OPTIONS

  end
end

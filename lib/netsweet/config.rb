module Netsweet
  class Config
    extend Util

    OPTIONS = [
      :account,
      :api_version,
      :company,
      :host,
      :mock_mode,
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
      :wsdl_url,
    ]

    attr_accessor(*OPTIONS)
    bool_setter :sandbox, :mock_mode

    def validate_configuration!
      errors = OPTIONS.select do |attr|
        "Netsweet.config.#{attr}" if send(attr).nil?
      end

      return if errors.empty?

      message = "The following configuration options are required: #{errors}"
      raise Netsweet::ConfigurationError, message
    end
  end
end

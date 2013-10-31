module Netsweet
  class SSO

    def self.generate_auth_token(customer)
      @token = SecureRandom.urlsafe_base64
    end

    def self.encrypt_token(token)
      token.reverse
    end

    # soap2r provides SsoCredentials, MapSsoRequest, and NetSuitePortType
    def self.map_sso(customer, password)
      raise SOAP::FaultError if mock_soap_error

      @mapped = true

    rescue SOAP::FaultError => ex
      raise Netsweet::MapSSOFailed.new(ex.message)
    end

    private

    # stub me to test failures
    def mock_soap_error
      false
    end

  end
end

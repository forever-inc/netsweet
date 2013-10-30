module Netsweet
  class SSO

    def self.generate_auth_token(customer)
      string_token = "#{Netsweet.config.company} #{customer.external_id} #{timestamp}"

      encrypt_token(string_token)
    end

    def self.encrypt_token(token)
      key_file.private_encrypt(token).unpack("H*")[0].upcase
    end

    # soap2r provides SsoCredentials, MapSsoRequest, and NetSuitePortType
    def self.map_sso(customer, password)
      hex_token = generate_auth_token(customer)
      # SsoCredentials.initialize(email = nil, password = nil, account = nil, role = nil, authenticationToken = nil, partnerId = nil)
      credentials = SsoCredentials.new(customer.email, password, Netsweet.config.account, customer.access_role, hex_token, Netsweet.config.partner)
      request = MapSsoRequest.new
      request.ssoCredentials = credentials
      client = NetSuitePortType.new
      client.mapSso(request)
    rescue SOAP::FaultError => ex
      raise Netsweet::MapSSOFailed.new(ex.message)
    end

    private

    def self.key_file
      @@key_file ||= OpenSSL::PKey::RSA.new(File.read(Netsweet.config.private_key_path), Netsweet.config.private_key_passphrase)
    end

    def self.timestamp
      time = Time.now
      (time.to_i * 1000) + (time.usec / 1000)
    end

  end
end

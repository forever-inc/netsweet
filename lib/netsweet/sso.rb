module Netsweet
  class SSO

    def self.generate_auth_token(customer)
      string_token = "#{Netsweet.config.company} #{customer.external_id} #{timestamp}"

      encrypt_token(string_token)
    end

    def self.encrypt_token(token)
      key_file.private_encrypt(token).unpack("H*")[0].upcase
    end

    def self.mapsso(customer)
      # Soap4R provides SsoCredentials, MapSsoRequest, and NetSuitePortType
      hex_token = generate_auth_token(customer)
      credentials = SsoCredentials.new(customer.email,
                                       rand_password,
                                       Netsweet.config.company,
                                       0, # not sure
                                       hex_token,
                                       Netsweet.config.company
                                      )
      request = MapSsoRequest.new
      request.ssoCredentials = credentials
      client = NetSuitePortType.new
      client.mapSso(request)
    end

    private

    def self.rand_password
      SecureRandom.urlsafe_base64
    end

    def self.key_file
      @@key_file ||= OpenSSL::PKey::RSA.new(File.read(Netsweet.config.private_key_path), Netsweet.config.private_key_passphrase)
    end

    def self.timestamp
      time = Time.now
      (time.to_i * 1000) + (time.usec / 1000)
    end

  end
end

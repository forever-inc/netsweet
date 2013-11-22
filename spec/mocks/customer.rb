require 'ostruct'

module Netsweet
  class Customer
    ATTRS = [
      :access_role,
      :email,
      :external_id,
      :first_name,
      :give_access,
      :internal_id,
      :is_person,
      :last_name,
      :password,
      :password2
    ]
    attr_accessor(*ATTRS)

    def initialize(struct)
      ATTRS.each do |attr|
        send("#{attr}=".to_sym, struct.send(attr))
      end
    end

    def gen_auth_token
      @token = SecureRandom.urlsafe_base64
    end

    def map_sso(password)
      @mapped = true
    end

    def delete
      @deleted = true
    end

    def self.create(attrs = {})
      yield attrs if block_given?
      validate_attributes!(attrs)

      rvp_customer = OpenStruct.new(attrs)
      Customer.new(rvp_customer)
    end

    def self.get(external_id)
      raise NetSuite::RecordNotFound if mock_not_found

      Customer.new(OpenStruct.new(external_id: external_id))

    rescue NetSuite::RecordNotFound
      raise Netsweet::CustomerNotFound.new("Could not find Customer with external_id = #{external_id}")
    end

    private

    # stub me to test failures
    def self.mock_not_found
      false
    end

    # if we need to do this in more places, or more robustly,
    # we probably should pull in Virtus.
    def self.validate_attributes!(attrs)
      missing_fields = required_creation_fields - attrs.keys
      if missing_fields.empty?
        raise ArgumentError.new("Missing required fields: #{missing_fields}")
      end
    end

    def self.required_creation_fields
      @required_creation_fields = ATTRS
    end
  end
end

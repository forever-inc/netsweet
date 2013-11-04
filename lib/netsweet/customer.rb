require 'forwardable'

module Netsweet
  class Customer

    extend Forwardable
    def_delegators :@rvp_customer, :external_id, :internal_id, :email, :delete

    def initialize(revolution_prep_customer)
      @rvp_customer = revolution_prep_customer
    end

    def gen_auth_token
      Netsweet::SSO.generate_auth_token(self)
    end

    def map_sso(password)
      Netsweet::SSO.map_sso(self, password)
    end

    def self.create(attrs = {})
      attrs = attrs.dup # protect netsuite from modifying these
      yield attrs if block_given?
      validate_attributes!(attrs)

      rvp_customer = NetSuite::Records::Customer.new(attrs)
      rvp_customer.add

      Customer.new(rvp_customer)
    end

    def self.get(external_id)
      rvp_customer = NetSuite::Records::Customer.get(external_id: external_id)
      Customer.new(rvp_customer)
    rescue NetSuite::RecordNotFound => ex
      raise Netsweet::CustomerNotFound.new("Could not find Customer with external_id = #{external_id}")
    end

    private

    # if we need to do this in more places, or more robustly, we probably should pull in Virtus.
    def self.validate_attributes!(attrs)
      missing_fields = required_creation_fields - attrs.keys
      if missing_fields.empty?
        raise ArgumentError.new("Missing required fields: #{missing_fields}")
      end
    end

    def self.required_creation_fields
      @required_creation_fields ||= [
        :access_role,
        :email,
        :entity_id,
        :external_id,
        :first_name,
        :give_access,
        :is_person,
        :last_name,
        :password,
        :password2
      ]
    end

  end
end

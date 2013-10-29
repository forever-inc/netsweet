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

    def self.create(attrs = {})
      yield attrs if block_given?

      # RevolutionPrep Customer Notes:
      # Here is the list of additional fields (with field names from the WSDL) to be set on a Customer record to assign access to a user via SOAP request:
      # giveAccess, a Boolean field that should be set to true
      # accessRole, a RecordRef (reference to List/Record field in NetSuite).  Please set the reference to the Role with internal ID 1017 (this is the internal ID of the “Custom Customer Center” role)
      # password, a string field that should be set with the random password assigned for this Customer (this password should then be carried forward for use in the mapSSO call that would follow)
      # password2, a string field that should be set with the same random password assigned for this Customer
      rvp_customer = NetSuite::Records::Customer.new(
        external_id: attrs.fetch(:external_id),
        entity_id:   attrs.fetch(:entity_id),
        email:       attrs.fetch(:email),
        first_name:  attrs.fetch(:first_name),
        last_name:   attrs.fetch(:last_name),
        is_person:   attrs.fetch(:is_person)
      )
      rvp_customer.add
      Customer.new(rvp_customer)
    end

    def self.get(external_id)
      rvp_customer = NetSuite::Records::Customer.get(external_id: external_id)
      Customer.new(rvp_customer)
    rescue NetSuite::RecordNotFound => ex
      raise Netsweet::CustomerNotFound.new("Could not find Customer with external_id = #{external_id}")
    end

    def self.map_sso(customer)
      Netsweet::SSO.mapsso(customer)
    end

  end
end

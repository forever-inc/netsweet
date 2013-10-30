require 'forwardable'

module Netsweet
  class Customer

    extend Forwardable
    def_delegators :@rvp_customer, :external_id, :internal_id, :email, :delete, :access_role

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
      yield attrs if block_given?

      rvp_customer = NetSuite::Records::Customer.new(
        external_id: attrs.fetch(:external_id),
        entity_id:   attrs.fetch(:entity_id),
        email:       attrs.fetch(:email),
        first_name:  attrs.fetch(:first_name),
        last_name:   attrs.fetch(:last_name),
        password:    attrs.fetch(:password),
        password2:   attrs.fetch(:password),
        access_role: Netsweet.config.customer_access_role,
        give_access: true,
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

  end
end

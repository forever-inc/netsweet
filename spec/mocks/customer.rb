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
    attr_accessor *ATTRS


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

      rvp_customer = OpenStruct.new(
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
      Customer.new(rvp_customer)
    end

    def self.get(external_id)
      raise NetSuite::RecordNotFound if mock_not_found

      Customer.new(OpenStruct.new(external_id: external_id))

    rescue NetSuite::RecordNotFound => ex
      raise Netsweet::CustomerNotFound.new("Could not find Customer with external_id = #{external_id}")
    end

    private

    # stub me to test failures
    def self.mock_not_found
      false
    end

  end
end

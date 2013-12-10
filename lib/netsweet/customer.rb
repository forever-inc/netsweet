require 'ostruct'
require 'timeliness'

module Netsweet
  class Customer
    extend Translator

    attr_accessor :properties

    translate :properties do
      {
        :first_name   => :firstname,
        :last_name    => :lastname,
        :email        => :email,
        :internal_id  => :id,
        :entity_id    => :entityid,
        :external_id  => :entityid, # is this different than entity id on netsuite side?
        :access_role  => [:accessrole,  ->(v) { v[:internalid] }, ->(v) { { internalid: v } }],
        :date_created => [:datecreated, ->(v) { Timeliness.parse(v) }, nil],
      }
    end

    def initialize(properties={})
      @properties = ::OpenStruct.new(properties)
    end

    def gen_auth_token
      Netsweet::SSO.generate_auth_token(entity_id)
    end

    def map_sso(password)
      Netsweet::SSO.map_sso(self, password)
    end

    def destroy
      self.class.connection.destroy('Customer', internal_id)
    end

    def self.connection
      Netsweet::Client.new
    end

    def self.build_attributes(attrs)
      yielded = {}
      if block_given?
        yield yielded
      end
      attrs.merge(yielded)
    end

    def self.build_creation_attributes(attrs = {})
      attrs.each_with_object({}) do |(k,v), hsh|
        hsh[key_conversion(k)] = value_conversion(v)
      end
    end

    def self.create(attrs = {}, &block)
      props = build_attributes(attrs, &block)
      validate_creation_attributes!(props)
      results = connection.upsert('Customer', [build_creation_attributes(props)])

      if results.empty?
        raise CustomerNotCreated.new("Customer: \"#{props}\" could not be created.")
      elsif results.count > 1
        raise MultipleCustomersCreated.new("Multiple Customers were just created: #{results.map(&:first).join(", ")}")
      else
        id, props = results.first
        Customer.new(props.merge(id: id)).refresh
      end
    end

    def self.find_by_internal_id(internal_id)
      properties = connection.get_record("Customer", internal_id)
      Customer.new(properties)
    rescue Netsweet::RecordNotFound
      raise Netsweet::CustomerNotFound.new("Could not find Customer with internal_id = #{internal_id}")
    end

    def self.search_by_email(email)
      results = connection.search_records("Customer", "email", email, "contains", return_columns)
      if results.count.zero?
        raise Netsweet::CustomerNotFound.new("Could not find Customer with email = #{email}")
      else
        results.map { |properties| Customer.new(properties) }.sort_by(&:date_created)
      end
    end

    def self.search_by_external_id(external_id)
      results = connection.search_records("Customer", "externalid", external_id, "is", return_columns)
      if results.count.zero?
        raise Netsweet::CustomerNotFound.new("Could not find Customer with external_id = #{external_id}")
      else
        results.map { |properties| Customer.new(properties) }.sort_by(&:date_created)
      end
    end

    def self.find_by_email(email)
      customers = search_by_email(email)
      if customers.count > 1
        ids = customers.map(&:internal_id)
        raise Netsweet::CustomerEmailNotUnique.new("Found #{ids.count} records found with the email '#{email}' (internal IDs = #{ids})")
      end
      customers.first
    end

    def self.find_by_external_id(external_id)
      customers = search_by_external_id(external_id)
      if customers.count > 1
        ids = customers.map(&:external_id)
        raise Netsweet::CustomerEmailNotUnique.new("Found #{ids.count} records found with the external_id '#{external_id}' (internal IDs = #{ids})")
      end
      customers.first
    end

    def refresh
      Customer.find_by_internal_id(self.internal_id)
    end


    private

    def self.validate_creation_attributes!(attrs)
      missing_fields = required_creation_fields - attrs.keys
      unless missing_fields.empty?
        raise ArgumentError.new("Missing required fields: #{missing_fields}")
      end

      if attrs[:password].length > 16
        raise ArgumentError.new('Passwords are capped at 16 characters.')
      end

      if attrs[:password] != attrs[:password2]
        raise ArgumentError.new('Passwords must match!')
      end
    end

    def self.return_columns
      @return_columns ||=
        [:email, :firstname, :lastname, :datecreated, :entityid, :externalid]
    end

    def self.required_creation_fields
      @required_creation_fields ||=
        [:access_role, :email, :entity_id, :first_name, :give_access, :is_person, :last_name, :password, :password2]
    end

    def self.key_conversion(key)
      # convert from snake case to netsuite madness
      key.to_s.gsub("_", "")
    end

    def self.value_conversion(val)
      # convert from booleans to netsuite truthy madness
      case val
      when true
        "T"
      when false
        "F"
      else
        val
      end
    end
  end
end

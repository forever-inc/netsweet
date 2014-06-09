require 'ostruct'
require 'timeliness'

module Netsweet
  class Customer
    extend Translator

    attr_accessor :properties

    # translate ruby properties to/from NetSuite properties
    translate :properties do
      {
        first_name:   :firstname,
        last_name:    :lastname,
        email:        :email,
        internal_id:  :id,
        external_id:  [:externalid,  ->(v) { v[:internalid] }, ->(v) { { internalid: v } }],
        access_role:  [:accessrole,  ->(v) { v[:internalid] }, ->(v) { { internalid: v } }],
        tax_item:     [:taxitem,     ->(v) { v[:name] },       ->(v) { { name: v } }],
        date_created: [:datecreated, ->(v) { Timeliness.parse(v) }, nil],
      }
    end

    def initialize(properties={})
      @properties = ::OpenStruct.new(properties)
    end

    def refresh
      Customer.find_by_internal_id(internal_id)
    end

    def gen_auth_token
      Netsweet::SSO.generate_auth_token(external_id)
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

    def self.search_by_email(email)
      search("email", email, "contains")
    end

    def self.search_by_internal_id(internal_id)
      search("internalid", internal_id, "is")
    end

    def self.search_by_external_id(external_id)
      search("externalidstring", external_id, "is")
    end

    def self.method_missing(meth, *args, &block)
      if meth.to_s =~ /^find_by_(?<attribute>.+)$/
        send(:find, Regexp.last_match[:attribute], *args, &block)
      else
        super
      end
    end

    def self.respond_to?(meth)
      if meth.to_s =~ /^find_by_.*$/
        true
      else
        super
      end
    end

    def self.find(field, value)
      customers = send("search_by_#{field}", value)
      if customers.count > 1
        ids = customers.map(&field.to_sym)
        raise Netsweet::CustomerNotUnique.new("Found #{ids.count} records found with the field id '#{field}' (internal IDs = #{ids})")
      end
      customers.first
    end

    def self.search(field, value, operator="is")
      results = connection.search_records("Customer", field, value, operator, return_columns)
      if results.count.zero?
        raise Netsweet::CustomerNotFound.new("Could not find Customer with query:  #{field} '#{operator}' #{value}")
      else
        results.map { |properties| Customer.new(properties) }.sort_by(&:date_created)
      end
    end

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
        [:email, :firstname, :lastname, :datecreated, :externalid, :taxitem]
    end

    def self.required_creation_fields
      @required_creation_fields ||=
        [:access_role, :email, :first_name, :give_access, :is_person, :last_name, :password, :password2, :external_id]
    end

    def self.build_attributes(attrs)
      yielded = {}
      if block_given?
        yield yielded
      end
      attrs.merge(yielded)
    end

    def self.build_creation_attributes(attrs = {})
      attrs.each_with_object({}) do |(k, v), hsh|
        hsh[key_conversion(k)] = value_conversion(v)
      end
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

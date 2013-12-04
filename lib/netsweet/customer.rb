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
        :internal_id  => :id,
        :email        => :email,
        :entity_id    => :entityid,
        :date_created => [:datecreated, ->(d) { Timeliness.parse(d) }]
      }
    end

    def self.connection
      Netsweet::Client.new
    end

    def initialize(properties={})
      @properties = ::OpenStruct.new(properties)
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
      results = connection.search_records("Customer", "entityid", external_id, "is", return_columns)
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

    def self.validate_attributes!(attrs)
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
        [:email, :firstname, :lastname, :datecreated, :entityid]
    end

    def self.required_creation_fields
      @required_creation_fields ||=
        [:access_role, :email, :entity_id, :external_id, :first_name, :give_access, :is_person, :last_name, :password, :password2]
    end
  end
end

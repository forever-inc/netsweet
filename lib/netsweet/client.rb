module Netsweet
  class Client
    attr_reader :connection, :response

    def initialize
      @connection = Connection.new
    end

    def get_record(ns_type, ns_id)
      call do
        connection.get_record(ns_type, ns_id)
      end
    end

    def upsert(ns_type, queries)
      connection.upsert(ns_type, queries)
    end

    def search_records(ns_type, ns_field_name, ns_field_value, ns_operator='is', return_columns)
      raise ClientError.new("A search value must be provided") if ns_field_value.blank?

      call do
        query    = build_query(ns_field_name, ns_field_value, ns_operator)
        response = connection.search_records(ns_type, query, return_columns)
        response.map do |properties|
          # elevate :column results to top level
          properties.merge(properties.delete(:columns))
        end
      end
    end

    def build_query(field_name, field_value, operator="is")
      { field_name.to_s => { "value" => field_value, "operator" => operator } }
    end


    private

    def call(&blk)
      @response = yield blk
      raise error unless valid?
      @response
    end

    def valid?
      return true if response.empty?
      response.is_a?(Hash) || response[0].is_a?(Hash) # yes, seriously.
    end

    def error
      msg = response.empty? ? "No results returned" : response.join(' ')
      raise error_klass(response[0]).new(msg)
    end

    def error_klass(code)
      case code
      when "RCRD_DSNT_EXIST"
        RecordNotFound
      else
        ClientError
      end
    end
  end
end

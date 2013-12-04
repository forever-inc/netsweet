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

    def search_records(ns_type, ns_field_name, ns_field_value, ns_operator='is', return_columns)
      raise ClientError.new("A search value must be provided") if ns_field_value.blank?

      call do
        query    = { "#{ns_field_name}" => { "value" => ns_field_value, "operator" => ns_operator } }
        response = connection.search_records(ns_type, query, return_columns)
        response.map do |properties|
          # elevate :column results to top level
          properties.merge(properties.delete(:columns))
        end
      end
    end


    private

    def call(&blk)
      @response = yield blk
      raise error unless valid?
      @response
    end

    def valid?
      response.is_a?(Hash) || response[0].is_a?(Hash) # yes, seriously.
    end

    def error
      raise error_klass(response[0]).new(response.join(' '))
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

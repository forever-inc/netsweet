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
      call do
        connection.upsert(ns_type, queries)
      end
    end

    def destroy(ns_type, ids)
      results      = connection.destroy(ns_type, ids)
      result_pairs = results.each_slice(2).to_a
      if result_pairs.all? { |_value, result_code| result_code == false }
        true # in the netsuite world, false means successful
      else
        raise ClientError.new("The following #{ns_type} could not be destroyed: #{result_pairs.map { |r| r[0] unless r[1] == false }}")
      end
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
      return true if response.flatten[0].is_a?(Hash)
      return true if response.flatten[0].to_i != 0 # first element is numeric internal id
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

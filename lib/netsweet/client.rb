# Encoding: utf-8

module Netsweet
  class Client
    attr_reader :connection

    def initialize
      @connection = Connection.new
    end

    def fetch_product(product)
      connection.get_record(product.ns_type, product.ns_id)
    end
  end
end

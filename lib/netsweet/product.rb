module Netsweet
  class Product
    attr_reader :name, :kind, :ns_type, :ns_id

    def initialize(name, kind, ns_type, ns_id)
      @name = name
      @kind = kind
      @ns_type = ns_type
      @ns_id = ns_id
    end
  end
end

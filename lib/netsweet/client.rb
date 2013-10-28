module Netsweet
  class Client

    attr_reader :connection

    def initialize
      @connection = Connection.new
    end

    def fetch_product(product)
      connection.get_record(product.ns_type, product.ns_id)
    end

    def cart_url(sso_auth_token)
      "#{Config[:netsuite_host]}/pages/partners/singlesignon.jsp?pid=#{Config[:partner]}&pacct=#{Config[:company]}&a=#{sso_auth_token}"
    end

  end
end

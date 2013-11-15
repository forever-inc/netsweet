# Encoding: utf-8

module Netsweet
  class Connection

    attr_reader :conn

    def initialize
      # AcumenBrands Netsuite::Client
      @conn = Netsuite::Client.new(Netsweet.config.account,
      Netsweet.config.rest_username, Netsweet.config.rest_password,
      Netsweet.config.role, sandbox: Netsweet.config.sandbox)
    end

    def get_record(type, id)
      conn.get_record(type, id)
    end

  end
end

module Netsweet
  class Connection
    attr_reader :conn

    def initialize
      # AcumenBrands Netsuite::Client
      @conn = Netsuite::Client.new(Netsweet.config.account,
                                   Netsweet.config.rest_username,
                                   Netsweet.config.rest_password,
                                   Netsweet.config.role,
                                   sandbox: Netsweet.config.sandbox)
    end

    def get_record(type, id)
      call { conn.get_record(type, id) }
    end

    def search_records(type, query, return_columns=[])
      return_columns_hash = Hash[return_columns.zip([nil])]
      call { conn.search_records(type, query, return_columns_hash) }
    end

    def destroy(type, *ids)
      call { conn.delete(type, ids.flatten) }
    end

    def upsert(type, query)
      call { conn.upsert(type, query) }
    end


    private

    def call(&blk)
      yield blk
    rescue => e
      raise ConnectionError.new(e.message)
    end

  end
end

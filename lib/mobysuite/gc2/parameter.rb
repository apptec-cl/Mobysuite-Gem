module Mobysuite
  module GC2
    class Parameter < AuthorizationGc2 
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def table payload
        set_sender("GET", "integrations/parameters/table/#{payload}", payload)
      end

      def table_with_filter(payload, filter = nil)
        path = "parameters/table/#{payload}"
        path += "/parent/#{filter}" unless filter.nil?
        set_sender("GET", path, payload)
      end
    end
  end
end

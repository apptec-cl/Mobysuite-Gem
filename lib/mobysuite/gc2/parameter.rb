module Mobysuite
  module GC2
    class Parameter < AuthorizationGc2 
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def commune_list payload = nil
        set_sender("GET", "integrations/parameters/table/COMUNA", payload)
      end
    end
  end
end
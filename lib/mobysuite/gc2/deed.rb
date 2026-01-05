module Mobysuite
  module GC2
    class Deed < AuthorizationGc2
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def delivery_date payload
        
		    data = { idsErp: payload[:id_erp], fecha: payload[:date] }

        set_sender("POST", "integrations/deed/process/delivery-date", data)
      end
    end
  end
end
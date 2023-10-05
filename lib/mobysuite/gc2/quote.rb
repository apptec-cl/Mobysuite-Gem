module Mobysuite
  module GC2
    class Quote < AuthorizationGc2
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create payload
        payload = {
            "rut": payload[:rut],
            "fName": payload[:fName],
            "lName": payload[:lName],
            "email": payload[:email],
            "phone": payload[:phone],
            "source": payload[:source],
            "contact": payload[:contact],
            "project": payload[:project_id],
            "assets": payload[:assets],
        }
        set_sender("POST", "integrations/quotes", payload)
      end
    end
  end
end
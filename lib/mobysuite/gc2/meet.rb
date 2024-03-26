module Mobysuite
  module GC2
    class Meet < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create data
        payload = {
            "dni": data[:dni],
            "rut": data[:rut],
            "firstName": data[:fName],
            "lastName": data[:lName],
            "email": data[:email],
            "phone": data[:phone],
            "informationMedium": data[:informationMedium],
            "observation": data[:observation],
            "contactType": "MOBYMEET",
            "token": data[:token],
            "users": data[:users],
            "project_id": data[:project_id],
            "fechaProgramada": data[:fechaProgramada]
        }
        set_sender("POST", "integrations/mobymeet", payload)
      end
      def accept_reject data
        payload = {
            "contactEventId": data[:id],
            "status": data[:accept],
        }
        set_sender("POST", "integrations/mobymeet/accept-reject", payload)
      end
    end
  end
end
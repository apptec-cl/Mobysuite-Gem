module Mobysuite
  module GC2
    class Firm < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def accept data
        payload = {
          "portfolio_id": data[:portfolio_id],
        }
        payload.merge!(members: data[:members]) unless data[:members].nil?
        payload.merge!(is_autorized: data[:is_autorized]) unless data[:is_autorized].nil?
        payload.merge!(is_promise: data[:is_promise]) unless data[:is_promise].nil?
        payload.merge!(url_signed_document: data[:url_signed_document]) unless data[:url_signed_document].nil?
        set_sender("POST", "integrations/digitalSignatureConfirmation", payload)
      end
    end
  end
end
module Mobysuite
  module GC2
    class Opportunity < AuthorizationGc2
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def list payload = nil
        unless payload.nil?
          payload[:page] = (payload[:page].nil? ? 0 : payload[:page])
          payload[:size] = (payload[:size].nil? ? 0 : payload[:size])
        end
        set_sender("GET", "integrations/assets/available-opportunities", payload)
      end
    end
  end
end
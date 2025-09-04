module Mobysuite
  module GC2
    class Client < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def list payload = nil
        unless payload.nil?
          payload = {
            page: (payload[:page].nil? ? 0 : payload[:page]),
            size: (payload[:size].nil? ? 0 : payload[:size]),
            rut: payload[:rut]
          }
        end
        set_sender("GET", "integrations/customers/rut/#{payload[:rut]}", payload)
      end
    end
  end
end
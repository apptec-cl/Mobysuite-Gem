module Mobysuite
  module GC2
    class Project < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def list payload = nil
        unless payload.nil?
          payload = {
            page: (payload[:page].nil? ? 0 : payload[:page]),
            size: (payload[:size].nil? ? 0 : payload[:size])
          }
        end
        set_sender("GET", "integrations/projects", payload)
      end
    end
  end
end
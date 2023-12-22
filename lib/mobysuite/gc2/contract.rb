module Mobysuite
  module GC2
    class Contract < AuthorizationGc2

        def initialize domain, client_id = nil, client_secret = nil
            super(domain, client_id, client_secret)
            @token = auth[:token]
        end

        def list payload = {}
          c_format = payload[:contract_format].nil? ? "?" : "?cFormat=#{payload[:contract_format].to_s}"
          if !payload[:client_id].nil?
            return set_sender("GET", "integrations/contracts#{c_format}&cId=#{payload[:client_id].to_s}")
          elsif !payload[:client_rut].nil?
            return set_sender("GET", "integrations/contracts#{c_format}&cName=#{payload[:client_rut].to_s}")
          end
        end
    end
  end
end
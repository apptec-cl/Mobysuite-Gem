module Mobysuite
  module GC2
    class Contract < AuthorizationGc2

        def initialize domain, client_id = nil, client_secret = nil
            super(domain, client_id, client_secret)
            @token = auth[:token]
        end

        def list payload = {}
          params = []
          
          params << "cFormat=#{payload[:contract_format]}" unless payload[:contract_format].nil?
          params << "cId=#{payload[:client_id]}" unless payload[:client_id].nil?
          params << "cName=#{payload[:client_rut]}" unless payload[:client_rut].nil?
          params << "eContract=#{payload[:e_contract]}" unless payload[:e_contract].nil?
          params << "contract=#{payload[:contract_id]}" unless payload[:contract_id].nil?

          query_string = params.empty? ? "" : "?#{params.join('&')}"
          
          return set_sender("GET", "integrations/contracts#{query_string}")
      end
    end
  end
end
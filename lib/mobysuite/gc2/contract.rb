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

        def reverse data = {}
          payload = {}

          if data[:contract_id].nil?
            payload.merge!(numeroBien: data[:numero_bien]) 
            payload.merge!(tipoBienEnum: data[:tipo_bien])
          else
            payload.merge!(contractId: data[:contract_id])
          end

          payload.merge!(numeroBien: data[:numero_bien]) unless data[:numero_bien].nil?
          payload.merge!(tipoBienEnum: data[:tipo_bien]) unless data[:tipo_bien].nil?
          payload.merge!(tipo: data[:tipo]) unless data[:tipo].nil?
          payload.merge!(monto: data[:monto]) unless data[:monto].nil?
          payload.merge!(multa: data[:multa]) unless data[:multa].nil?
          payload.merge!(multaMonedaLocal: data[:multa_moneda_local]) unless data[:multa_moneda_local].nil?
          payload.merge!(devolucion: data[:devolucion]) unless data[:devolucion].nil?
          payload.merge!(retencion: data[:retencion]) unless data[:retencion].nil?
          payload.merge!(observacion: data[:observacion]) unless data[:observacion].nil?

          return set_sender("POST", "integrations/contracts/reverse", payload)
        end

      def change_state data = {}
        payload = {}

        if data[:contract_id].nil?
          payload.merge!(numeroBien: data[:numero_bien]) 
          payload.merge!(tipoBienEnum: data[:tipo_bien])
        else
          payload.merge!(contractId: data[:contract_id])
        end
        payload.merge!(nuevoEstado: data[:contract_state])
        return set_sender("POST", "integrations/contracts/sync-state", payload)
      end
    end
  end
end
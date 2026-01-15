module Mobysuite
  module GC2
    class Prospect < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def badge data
        payload = {
            "module":   data[:module],
            "value":    data[:value],
            "message":  data[:message],
            "chatbot":  data[:chatbot],
            "phone_id": data[:phone_id],
          }
        payload[:phone_id] = data[:phone_id] unless data[:phone_id].nil?
        payload[:chatb_id] = data[:chatb_id] unless data[:chatb_id].nil?
        payload[:assetId] = data[:asset_id] unless data[:asset_id].nil?
        
        set_sender("POST", "integrations/badge", payload)
      end
            

      def create data
        payload = {
            "dni": (data[:dni].nil? ? false : data[:dni]),
            "rut": data[:rut],
            "fName": data[:fName],
            "lName": data[:lName],
            "bussinesNameType": data[:bussines_name_type],
            "email": data[:email],
            "phone": data[:phone],
            "rangoRenta": data[:rango_renta],
            "informationMedium": data[:information_medium],
            "observation": data[:observation],
            "source": (data[:source].nil? ? "CENTRALIZADOR" : data[:source]),
            "cip": (data[:cip].nil? ? nil : data[:cip]),
            "utm_source": (data[:utm_source].nil? ? nil : data[:utm_source]),
            "utm_campaign": (data[:utm_campaign].nil? ? nil : data[:utm_campaign]),
            "utm_medium": (data[:utm_medium].nil? ? nil : data[:utm_medium]),
            "utm_term": (data[:utm_term].nil? ? nil : data[:utm_term]),
            "utm_content": (data[:utm_content].nil? ? nil : data[:utm_content]),
            "isSync": data[:isSync].nil? ? false : data[:isSync],
        }
        payload[:tipoComprador] = data[:tipo_comprador] unless data[:tipo_comprador].nil?
        payload[:userId] = data[:user_id] unless data[:user_id].nil?
        if data[:project_name].nil?
          payload[:project_id]  = data[:project_id]
        else
          payload[:projectName] = data[:project_name]
        end
        set_sender("POST", "integrations/customers", payload)
      end
    end
  end
end
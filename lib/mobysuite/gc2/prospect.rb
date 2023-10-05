module Mobysuite
  module GC2
    class Prospect < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
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
            "utm_campaign": (data[:utm_campaign].nil? ? nil : data[:utm_campaign])
        }
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
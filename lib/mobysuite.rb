require "mobysuite/version"
require "mobysuite/auth"

module Mobysuite

  module GC2

    class Quote < AuthorizationGc2

      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create payload
        payload = {
              "rut": payload[:rut],
              "fName": payload[:fName],
              "lName": payload[:lName],
              "email": payload[:email],
              "phone": payload[:phone],
              "source": payload[:source],
              "contact": payload[:contact],
              "project": payload[:project_id],
              "assets": payload[:assets],
          }
        set_sender("POST", "integrations/quotes", payload)
      end
    end

    class Prospect < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create payload
        payload = {
          "rut": payload[:rut],
          "dni":	false,
          "fName": payload[:fName],
          "lName": payload[:lName],
          "email":  payload[:email],
          "phone": payload[:phone],
          "projectName": payload[:project_name],
          "observation": payload[:observation],
          "metadata": payload[:metadata],
        }
        set_sender("POST", "integrations/customers", payload)
      end
    end
  end
end

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

    class Asset < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def list payload
          payload = {
            projectId: payload[:project_id],
            departmentTypology: payload[:department_typology],
            assetNumber: payload[:asset_number],
            assetType: payload[:asset_type],
            projectStage: payload[:project_stage],
            page: (payload[:page].nil? ? 0 : payload[:page]),
            size: (payload[:size].nil? ? 0 : payload[:size])
          }
        set_sender("GET", "integrations/assets?page=#{payload[:page]}&size=#{payload[:size]}", payload)
      end

      def types payload
        return {response: false, body: nil, msg: "You need project_id to this endpoint"} if payload[:project_id].nil?
        payload = {
          page: (payload[:page].nil? ? 0 : payload[:page]),
          size: (payload[:size].nil? ? 0 : payload[:size]),
          project_id: payload[:project_id]
        }
        set_sender("GET", "integrations/asset-types/project/#{payload[:project_id]}?page=#{payload[:page]}&size=#{payload[:size]}")
      end

    end
 
    class Project < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def list payload = nil
        unless payload.nil?
          payload = {
            page: (payload[:page].empty? ? 0 : payload[:page]),
            size: (payload[:size].empty? ? 0 : payload[:size])
          }
        end
        set_sender("GET", "integrations/projects", payload)
      end
    end

    class Parameter < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def commune_list payload = nil
        set_sender("GET", "integrations/parameters/table/COMUNA", payload)
      end
    end

  end
end

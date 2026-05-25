module Mobysuite
  module GC2
    class Asset < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def edit payload
		    payload.merge!(estadoBien: payload[:asset_status]) unless payload[:asset_status].nil?
        payload.merge!(id: payload[:id]) unless payload[:id].nil?
        payload.merge!(idErp: payload[:id_erp]) unless payload[:id_erp].nil?
        set_sender("POST", "integrations/assets", [payload])
      end

      def list payload
          params = {
            projectId: payload[:project_id],
            departmentTypology: payload[:department_typology],
            assetNumber: payload[:asset_number],
            assetType: payload[:asset_type],
            projectStage: payload[:project_stage],
            page: payload[:page] || 0,
            size: payload[:size] || 0
          }.reject { |_, v| v.nil? }
          query_string = params.map { |k, v| "#{k}=#{v}" }.join("&")
        set_sender("GET", "integrations/assets?#{query_string}", params)
      end

      def list_all payload
          params = {
            projectId: payload[:project_id],
            departmentTypology: payload[:department_typology],
            assetNumber: payload[:asset_number],
            assetType: payload[:asset_type],
            projectStage: payload[:project_stage],
            page: payload[:page] || 0,
            size: payload[:size] || 0
          }.reject { |_, v| v.nil? }
          query_string = params.map { |k, v| "#{k}=#{v}" }.join("&")
        set_sender("GET", "integrations/assets/all-assets?#{query_string}", params)
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

      def client_assets_project payload = nil
        unless payload.nil?
          payload = {
            project: payload[:project_id]
          }
        end
        set_sender("GET", "integrations/assets/list-client-assets-by-project?project=#{payload[:project]}")
      end
    end
  end
end
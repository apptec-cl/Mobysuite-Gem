module Mobysuite
    module GC2
      class Amc < AuthorizationGc2
        
        def initialize domain, client_id = nil, client_secret = nil
          super(domain, client_id, client_secret)
          @token = auth[:token]
        end
  
        def documents payload = nil
          set_sender("GET", "integrations/amc/documents/"+payload[:contract_id].to_s)
        end
  
        def sidebar payload = nil
          set_sender("GET", "integrations/amc/sidebar-content/"+payload[:project_id].to_s)
        end
  
        def content payload = nil
          set_sender("GET", "integrations/amc/content/"+payload[:project_id].to_s)
        end
      end
    end
  end
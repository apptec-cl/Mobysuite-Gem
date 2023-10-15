module Mobysuite
  module GC2
    class Quote < AuthorizationGc2
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create payload
        data = {
            "rut": (payload[:rut].nil? ? payload[:dni] : payload[:rut]),
            "fName": payload[:fName],
            "lName": payload[:lName],
            "email": payload[:email],
            "phone": payload[:phone],
            "source": payload[:source],
            "contact": payload[:contact],
            "project": payload[:project_id],
            "assets": payload[:assets],
        }
        #Validate optional paramss
        data.merge!("dni": true) unless payload[:dni].nil?
        data.merge!("profesion": payload[:profesion]) unless payload[:profesion].nil?
        data.merge!("comuna": payload[:comuna]) unless payload[:comuna].nil?
        data.merge!("ageRange": payload[:ageRange]) unless payload[:ageRange].nil?
        data.merge!("destinationPurchase": payload[:destinationPurchase]) unless payload[:destinationPurchase].nil?
        data.merge!("receiveNews": payload[:receiveNews]) unless payload[:receiveNews].nil?
        data.merge!("observation": payload[:observation]) unless payload[:observation].nil?
        data.merge!("rentRange": payload[:rentRange]) unless payload[:rentRange].nil?
        data.merge!("sex": payload[:sex]) unless payload[:sex].nil?
        data.merge!("discountId": payload[:discountId]) unless payload[:discountId].nil?
        data.merge!("source": payload[:source]) unless payload[:source].nil?
        data.merge!("contact": payload[:contact]) unless payload[:contact].nil?
        data.merge!("utm_campaign": payload[:utm_campaign]) unless payload[:utm_campaign].nil?
        data.merge!("utm_content": payload[:utm_content]) unless payload[:utm_content].nil?
        data.merge!("utm_medium": payload[:utm_medium]) unless payload[:utm_medium].nil?
        data.merge!("utm_source": payload[:utm_source]) unless payload[:utm_source].nil?
        data.merge!("utm_term": payload[:utm_term]) unless payload[:utm_term].nil?
        set_sender("POST", "integrations/quotes", data)
      end
    end
  end
end
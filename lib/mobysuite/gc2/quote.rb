module Mobysuite
  module GC2
    class Quote < AuthorizationGc2
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def create payload
        payload = {
            "rut": (payload[:rut].blank? ? payload[:dni] : payload[:rut]),
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
        payload.merge!("dni": true) unless payload[:dni].blank?
        payload.merge!("profesion": payload[:profesion]) unless payload[:profesion].blank?
        payload.merge!("comuna": payload[:comuna]) unless payload[:comuna].blank?
        payload.merge!("ageRange": payload[:ageRange]) unless payload[:ageRange].blank?
        payload.merge!("destinationPurchase": payload[:destinationPurchase]) unless payload[:destinationPurchase].blank?
        payload.merge!("receiveNews": payload[:receiveNews]) unless payload[:receiveNews].blank?
        payload.merge!("observation": payload[:observation]) unless payload[:observation].blank?
        payload.merge!("rentRange": payload[:rentRange]) unless payload[:rentRange].blank?
        payload.merge!("sex": payload[:sex]) unless payload[:sex].blank?
        payload.merge!("discountId": payload[:discountId]) unless payload[:discountId].blank?
        payload.merge!("source": payload[:source]) unless payload[:source].blank?
        payload.merge!("contact": payload[:contact]) unless payload[:contact].blank?
        payload.merge!("utm_campaign": payload[:utm_campaign]) unless payload[:utm_campaign].blank?
        payload.merge!("utm_content": payload[:utm_content]) unless payload[:utm_content].blank?
        payload.merge!("utm_medium": payload[:utm_medium]) unless payload[:utm_medium].blank?
        payload.merge!("utm_source": payload[:utm_source]) unless payload[:utm_source].blank?
        payload.merge!("utm_term": payload[:utm_term]) unless payload[:utm_term].blank?
        set_sender("POST", "integrations/quotes", payload)
      end
    end
  end
end
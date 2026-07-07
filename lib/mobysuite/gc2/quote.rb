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
        data.merge!("userId": payload[:userId]) unless payload[:userId].nil?
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

      def calculate_gloss payload
        params = {
          years: payload[:years],
          rate: payload[:rate],
          constant: payload[:constant],
          mortgageCredit: payload[:mortgageCredit],
          fees: payload[:fees],
          feesTotalAmmount: payload[:feesTotalAmmount]
        }
        missing = params.select { |_, v| v.nil? }.keys
        return {response: false, body: nil, msg: "Missing required params: #{missing.join(', ')}"} unless missing.empty?
        query_string = params.map { |k, v| "#{k}=#{v}" }.join("&")
        response = set_sender("GET", "integrations/quotes/caculate-gloss?#{query_string}", params)
        return response unless response[:response] && response[:body].is_a?(Hash)
        response[:body].merge!(parse_gloss(response[:body]["gloss"], response[:body]["feesGloss"]))
        response
      end

      private

      # Parses the gloss strings returned by the service and appends the
      # separated values to the response body.
      #   gloss     -> "Dividendo aproximado a 20 años: UF: 23,81 al 5,50%. Valor Dividendo : $904.856 Renta mínima : $3.619.426"
      #   feesGloss -> "12 cuotas de 0.4375 UF c/u."
      def parse_gloss gloss, fees_gloss
        parsed = {}
        unless gloss.nil?
          parsed["years"]        = gloss[/(\d+)\s*años/, 1]&.to_i
          parsed["dividendUf"]   = to_number(gloss[/UF:\s*([\d.,]+)/, 1])
          parsed["rate"]         = to_number(gloss[/al\s*([\d.,]+)%/, 1])
          parsed["dividend"]     = to_number(gloss[/Valor Dividendo\s*:\s*\$([\d.,]+)/, 1])
          parsed["minimumIncome"] = to_number(gloss[/Renta mínima\s*:\s*\$([\d.,]+)/, 1])
        end
        unless fees_gloss.nil?
          # feesGloss uses a plain dot as decimal separator (e.g. "0.4375"),
          # not the Chilean format used in gloss, so parse it directly.
          parsed["fees"]   = fees_gloss[/(\d+)\s*cuotas/, 1]&.to_i
          parsed["feesUf"] = fees_gloss[/de\s*([\d.]+)\s*UF/, 1]&.to_f
        end
        parsed
      end

      # Converts a Chilean-formatted number (dot as thousands separator,
      # comma as decimal separator) into a Float. Returns nil when blank.
      def to_number value
        return nil if value.nil? || value.strip.empty?
        normalized = value.strip.gsub(".", "").tr(",", ".")
        normalized.include?(".") ? normalized.to_f : normalized.to_i
      end
    end
  end
end
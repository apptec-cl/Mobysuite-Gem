module Mobysuite
  module GC2
    class Payment < AuthorizationGc2
      
      def initialize domain, client_id = nil, client_secret = nil
        super(domain, client_id, client_secret)
        @token = auth[:token]
      end

      def find payment_code
        set_sender("GET", "integrations/payments?paymentCode=#{payment_code}")
      end
      def pay data
        payload = {
          "payCode": data[:pay_code],
          "authCode": data[:auth_code],
          "cardNumber": data[:card_number],
          "amount": data[:amount],
          "totalPayments": data[:total_payments],
          "interestFreePayments": data[:interest_free_payments],
        }
        payload[:amount] = data[:amount] unless data[:amount].nil?
        payload[:tipePay] = data[:tipePay] unless data[:tipePay].nil?
        set_sender("POST", "integrations/payments", payload)
      end
      def active_payment_info data
        parameter = data[:contract_id].nil? ? "idAsset=#{data[:asset_id]}" : "idContract=#{data[:contract_id]}"
        set_sender("GET", "integrations/payments/add-automated-payments-info?#{parameter}&tipo=#{data[:type]}", data)
      end
    end
  end
end
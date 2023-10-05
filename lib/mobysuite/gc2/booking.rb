module Mobysuite
  module GC2
    class Booking < AuthorizationGc2

        def initialize domain, client_id = nil, client_secret = nil
            super(domain, client_id, client_secret)
            @token = auth[:token]
        end

        def create payload
            payload = {
              "quoteCode": payload[:quote_code],
              "authCode": payload[:auth_code],
              "cardNumber": payload[:card_number],
              "totalPayments": payload[:total_payments],
              "interestFreePayments": payload[:interest_free_payments],
              "rut": payload[:rut],
              "firstName": payload[:first_name],
              "lastName": payload[:last_name],
              "email": payload[:email],
              "phone": payload[:phone],
              "address": payload[:address],
              "number": payload[:number],
              "commune": payload[:commune],
              "city": payload[:city],
              "tipePay": payload[:tipe_pay]
              }
            set_sender("POST", "integrations/booking", payload)
        end
    end
  end
end
require 'mobysuite'

RSpec.describe Mobysuite::GC2::Payment do
  before do
    @payment = Mobysuite::GC2::Payment.new("try")
  end

  describe '#Payment' do
    it 'Search Payment' do
      response = @payment.find("P-VBSR45554")
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Make the payment' do
      response = @payment.pay({
        "pay_code": "P-YQVG45551",
        "auth_code": "test",
        "card_number": "1111",
        "total_payments": 3,
        "interest_free_payments":2,
      })
      p response
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
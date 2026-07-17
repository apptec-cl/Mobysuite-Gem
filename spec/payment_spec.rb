require 'mobysuite'

RSpec.describe Mobysuite::GC2::Payment do
  before do
    @payment = Mobysuite::GC2::Payment.new("try")
  end

  describe '#Payment' do

    it 'sends pay_id as payId when making a payment' do
      payment = described_class.allocate

      expect(payment).to receive(:set_sender).with(
        "POST",
        "integrations/payments",
        hash_including(payId: 123)
      ).and_return(response: true)

      payment.pay(pay_id: 123)
    end

    it 'rejects pay_id and pay_code together' do
      payment = described_class.allocate

      expect {
        payment.pay(pay_id: 123, pay_code: "P-YQVG45551")
      }.to raise_error(ArgumentError, "provide either pay_id or pay_code, but not both")
    end

    it 'requires pay_id or pay_code' do
      payment = described_class.allocate

      expect {
        payment.pay({})
      }.to raise_error(ArgumentError, "provide either pay_id or pay_code, but not both")
    end

    it 'Search Payment' do
      response = @payment.find("P-VBSR45554")
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Add Payment Info (PAC/PAT)' do
      response = @payment.active_payment_info({contract_id: 3679, type: "Fintoc"})
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

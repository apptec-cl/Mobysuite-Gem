require 'mobysuite'
# require 'pry'

RSpec.describe Mobysuite::GC2::Opportunity do
  before do
    @opportunity = Mobysuite::GC2::Opportunity.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @opportunity.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Opportunity' do
    it 'List' do
      response = @opportunity.list()
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
    it 'CalculatePaymentPlan' do
      opportunities = @opportunity.list()
      expect(opportunities[:body].nil?).to eq(false), 'No hay oportunidades disponibles.'
      opportunity = opportunities[:body][0]
      data = {
        "discountId": opportunity['descuentoGrupo'][0]['id'],
        "assets": [{'id': opportunity['id']}],
        "customer": 'demo2',
      }
      response = @opportunity.calculate_payment_plan(data)
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end
end
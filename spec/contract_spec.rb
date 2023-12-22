require 'mobysuite'

RSpec.describe Mobysuite::GC2::Contract do
  before do
    @contract = Mobysuite::GC2::Contract.new("demo2")
  end

  describe '#CONTRACT' do
    it 'ByRut' do
      response = @contract.list({client_rut: '19464782-4'})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end

    it 'ById' do
      response = @contract.list({client_id: 96759})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end
end
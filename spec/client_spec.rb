require 'mobysuite'

RSpec.describe Mobysuite::GC2::Client do
  before do
    @client = Mobysuite::GC2::Client.new("try")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @client.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end
  
  describe '#Client' do
    it 'List' do
      response = @client.list({rut: "17810699-6", page: 0, size: 10})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
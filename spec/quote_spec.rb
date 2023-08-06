require 'mobysuite'

RSpec.describe Mobysuite::GC2::Quote do
  before do
    @quote = Mobysuite::GC2::Quote.new("app", "mobysuite_quote", "G9#fRt5!")
  end

  describe '#Auth' do
    it 'succeeds' do
      response = @quote.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Create' do
    it 'creates something' do
      response = @quote.create({
        rut: "17810699-6",
        fName: "Matias",
        lName: "Menares",
        email: "mmenares@mobysuite.com",
        phone: "+56999999999",
        source: "mobysuite",
        contact: "mobysuite",
        tracker: nil,
        metadata: {}
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
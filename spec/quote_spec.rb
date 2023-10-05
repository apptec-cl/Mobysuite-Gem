require 'mobysuite'

RSpec.describe Mobysuite::GC2::Quote do
  before do
    @quote = Mobysuite::GC2::Quote.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @quote.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Quote' do
    it 'Create Quote' do
      response = @quote.create({
        rut: "14603229-k",
        fName: "Pepe",
        lName: "Cuenca",
        email: "pepe@cuenca.com",
        phone: "+56986565633",
        source: "COTIZADOR WEB",
        contact: "COTIZADOR WEB",
        project_id: 3,
        assets: [{
                asset: 813,
                type: "Departamento"
            }]
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
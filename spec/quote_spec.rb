require 'mobysuite'

RSpec.describe Mobysuite::GC2::Quote do
  before do
    @quote = Mobysuite::GC2::Quote.new("try")
    @asset = Mobysuite::GC2::Asset.new("try")
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
      assets = @asset.list({project_id: 5})
      expect(assets[:body].nil?).to eq(false), 'No hay departamentos disponibles.'
      apartment = assets[:body].select { |element| element["assetType"]["isPrimary"] && element["status"] == "DISPONIBLE" }
      sample = apartment.sample
      expect(sample.nil?).to eq(false), 'No hay departamento maestro disponible.'
      response = @quote.create({
        rut: "14603229-k",
        fName: "Pepe",
        lName: "Cuenca",
        email: "pepe@cuenca.com",
        phone: "+56986565633",
        source: "COTIZADOR WEB",
        contact: "COTIZADOR WEB",
        project_id: 5,
        assets: [{
                id: sample["id"],
            }]
      })
      expect(response[:body]['error'].nil?).to eq(true), "Hubo un error al cotizar. Mensaje de error: #{response[:body].to_s}"
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
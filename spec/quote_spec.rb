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

  describe '#calculate_gloss' do
    it 'Fails when a required param is missing' do
      response = @quote.calculate_gloss({ years: 20 })
      expect(response[:response]).to eq(false)
      expect(response[:msg]).to include('Missing required params')
    end

    it 'Parses the gloss strings into separated values' do
      gloss = "Dividendo aproximado a 20 años: UF: 23,81 al 5,50%. Valor Dividendo : $904.856 Renta mínima : $3.619.426"
      fees_gloss = "12 cuotas de 0.4375 UF c/u."

      parsed = @quote.send(:parse_gloss, gloss, fees_gloss)

      expect(parsed["years"]).to eq(20)
      expect(parsed["dividendUf"]).to eq(23.81)
      expect(parsed["rate"]).to eq(5.5)
      expect(parsed["dividend"]).to eq(904856)
      expect(parsed["minimumIncome"]).to eq(3619426)
      expect(parsed["fees"]).to eq(12)
      expect(parsed["feesUf"]).to eq(0.4375)
    end

    it 'Calculates and appends parsed values to the response body' do
      response = @quote.calculate_gloss({
        years: 20,
        rate: 0.055,
        constant: 38000,
        mortgageCredit: 3500,
        fees: 12,
        feesTotalAmmount: 5.25
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true), "Error al calcular glosa: #{response[:body].to_s}"
      expect(response[:body]["gloss"].nil?).to eq(false)
      expect(response[:body]["years"].nil?).to eq(false)
      expect(response[:body]["dividend"].nil?).to eq(false)
      expect(response[:body]["feesUf"].nil?).to eq(false)
    end
  end
end
require 'mobysuite'

RSpec.describe Mobysuite::GC2::Quote do
  before do
    @quote       = Mobysuite::GC2::Quote.new("demo2")
    @project     = Mobysuite::GC2::Project.new("demo2")
    @asset       = Mobysuite::GC2::Asset.new("demo2")
    @parameter   = Mobysuite::GC2::Parameter.new("demo2")
    @prospect    = Mobysuite::GC2::Prospect.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @quote.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Projects' do
    it 'List' do
      response = @project.list()
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end

  describe '#Assets' do
    it 'List' do
      response = @asset.list({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Types' do
      response = @asset.types({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end

  describe '#Parameter' do
    it 'List Commune' do
      response = @parameter.commune_list()
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

  describe '#Prospect' do
    it 'Create Prospect' do
      #projectName or project_id is required
      response = @prospect.create({
        "dni":false,
        "rut": "14.178.788-8",
        "fName": "viviana",
        "lName": "Doris",
        "bussines_name_type": "PERSONA_NATURAL",
        "email": "soporte@mobysuite.com",
        "phone": "+569",
        "project_id": 3,
        "rango_renta": nil,
        "information_medium": "INSTAGRAM",
        "observation": "Id formulario: Form NeoCentro v3 (965085314536396). ",
        "source": "CENTRALIZADOR",
        "cip": nil
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end

end
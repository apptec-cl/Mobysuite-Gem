require 'mobysuite'

RSpec.describe Mobysuite::GC2::Prospect do
  before do
    @prospect    = Mobysuite::GC2::Prospect.new("try")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @prospect.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Prospect' do
    it 'Create Prospect' do
      #projectName or project_id is required
      response = @prospect.create({
        "dni":false,
        "rut": "17.810.699-6",
        "fName": "Soporte",
        "lName": "Mobysuite",
        "bussines_name_type": "PERSONA_NATURAL",
        "email": "soporte@mobysuite.com",
        "phone": "+56972154899",
        "project_id": 1,
        "rango_renta": nil,
        "information_medium": "INSTAGRAM",
        "observation": "Id formulario: Form Soporte Mobysuite v3 (965085314536396). ",
        "source": "CENTRALIZADOR",
        "cip": nil
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
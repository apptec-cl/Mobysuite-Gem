require 'mobysuite'

RSpec.describe Mobysuite::GC2::Prospect do
  before do
    @prospect    = Mobysuite::GC2::Prospect.new("demo2")
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
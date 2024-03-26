require 'mobysuite'

RSpec.describe Mobysuite::GC2::Meet do
  before do
    @meet    = Mobysuite::GC2::Meet.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @meet.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Meet' do
    it 'Create Meet' do
      response = @meet.create({     
        "dni":true,
        "rut":"1234567-4",
        "fName":"Test",
        "lName":"Mobysuite",
        "email":"soporte@apptec.cl",
        "phone":"+56999999999",
        "project_id":1,
        "informationMedium":"",
        "contactType":"MOBYMEET",
        "observation":"test",
        "source":"",
        "users":[1,2,4,63],
        "cita":true,
        "token":"",
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
      response[:body]
      data = {
				"id": response[:body]["idEventoContacto"],
				"accept": true,
			}
      second_res = @meet.accept_reject(data)
      expect(second_res).to be_a(Hash)
      expect(second_res[:response]).to eq(true)
    end
  end
end
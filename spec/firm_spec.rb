require 'mobysuite'

RSpec.describe Mobysuite::GC2::Firm do
  before do
    @firm = Mobysuite::GC2::Firm.new("try")
  end

  describe '#Firm' do
    it 'Accept Sign' do
      response = @firm.accept({portfolio_id: "e41573e2-926b-4196-8eb0-afd1e6bb13a0", members: [{
              "name": "Alejandro",
              "lastname": "Flores",
              "rut": "22228048-6",
              "date_firm": Date.today.strftime("%Y-%m-%d"),
            }]})
      p response
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
    it 'Add Reservation' do
      response = @firm.accept({
       portfolio_id: "b9a56a17-6406-4118-862c-f14a7c64e95e",
       url_signed_document: "https://s24.q4cdn.com/216390268/files/doc_downloads/test.pdf"
      })
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
    it 'Move to Promise' do
      response = @firm.accept({portfolio_id: "e41573e2-926b-4196-8eb0-afd1e6bb13a0",
       is_autorized: true,
       is_promise: true})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
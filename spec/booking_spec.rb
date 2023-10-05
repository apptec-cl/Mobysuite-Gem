require 'mobysuite'
# require 'pry'

RSpec.describe Mobysuite::GC2::Booking do
  before do
    @booking = Mobysuite::GC2::Booking.new("demo2")
    @quote = Mobysuite::GC2::Quote.new("demo2")
    @asset = Mobysuite::GC2::Asset.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @booking.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Booking' do
    it 'Create Booking' do
      assets = @asset.list({project_id: 5})
      apartment = assets[:body].select { |element| element["assetTypeValue"] == "DEPARTAMENTO" && element["status"] == "DISPONIBLE" }
      sample = apartment.sample
      quote = @quote.create({
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
      if quote[:response]
        response = @booking.create({
          quote_code: quote[:body]["cotizacion"]["codigo"],
          auth_code: rand(1000..9999),
          card_number: rand(1000..9999),
          total_payments: "1",
          interest_free_payments: "1",
          rut: quote[:body]["cotizacion"]["cliente"]["rut"],
          first_name: quote[:body]["cotizacion"]["cliente"]["razonSocial"].split(" ")[0],
          last_name: quote[:body]["cotizacion"]["cliente"]["razonSocial"].split(" ")[1],
          email: quote[:body]["cotizacion"]["cliente"]["email"],
          phone: quote[:body]["cotizacion"]["cliente"]["telefonoUno"],
          address: "",
          number:"",
          commune:"",
          city:"",
          tipe_pay:"Webpay"
          })
      end
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
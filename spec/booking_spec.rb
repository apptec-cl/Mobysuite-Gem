require 'mobysuite'
# require 'pry'

RSpec.describe Mobysuite::GC2::Booking, '#create payload' do
  let(:booking) { described_class.allocate }
  let(:payload) do
    {
      quote_code: 'Q-TEST', auth_code: '1234', card_number: '5678',
      total_payments: '1', interest_free_payments: '1', rut: '14603229-k',
      first_name: 'Pepe', last_name: 'Cuenca', email: 'pepe@example.com',
      phone: '+56986565633', address: 'Calle de prueba', number: '123',
      commune: 'Santiago', city: 'Santiago', tipe_pay: 'Webpay'
    }
  end
  let(:expected_payload) do
    {
      quoteCode: 'Q-TEST', authCode: '1234', cardNumber: '5678',
      totalPayments: '1', interestFreePayments: '1', rut: '14603229-k',
      firstName: 'Pepe', lastName: 'Cuenca', email: 'pepe@example.com',
      phone: '+56986565633', address: 'Calle de prueba', number: '123',
      commune: 'Santiago', city: 'Santiago', tipePay: 'Webpay'
    }
  end

  it 'maps personal details to API keys without modifying the input' do
    input = payload.merge(
      birth_date: '1990-05-15', nationality: 'CHILENA', profession: 'Ingeniero',
      marital_status: 'SOLTERO', patrimonial_regime: 'SEPARACION_DE_BIENES'
    ).freeze
    response = { response: true, body: { 'id' => 123 } }

    expect(booking).to receive(:set_sender).with(
      'POST', 'integrations/booking', expected_payload.merge(
        birthDate: '1990-05-15', nationality: 'CHILENA', profession: 'Ingeniero',
        maritalStatus: 'SOLTERO', patrimonialRegime: 'SEPARACION_DE_BIENES'
      )
    ).and_return(response)

    expect(booking.create(input)).to eq(response)
  end

  it 'preserves the existing payload when optional personal details are absent' do
    expect(booking).to receive(:set_sender).with(
      'POST', 'integrations/booking', expected_payload
    ).and_return(response: true)

    booking.create(payload)
  end

  it 'omits optional personal details that are nil' do
    expect(booking).to receive(:set_sender).with(
      'POST', 'integrations/booking', expected_payload
    ).and_return(response: true)

    booking.create(payload.merge(
      birth_date: nil, nationality: nil, profession: nil,
      marital_status: nil, patrimonial_regime: nil
    ))
  end
end

RSpec.describe Mobysuite::GC2::Booking do
  before do
    @booking = Mobysuite::GC2::Booking.new("try")
    @quote = Mobysuite::GC2::Quote.new("try")
    @asset = Mobysuite::GC2::Asset.new("try")
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
      expect(assets[:body].nil?).to eq(false), 'No hay departamentos disponibles.'
      apartment = assets[:body].select { |element| element["assetType"]["isPrimary"] && element["status"] == "DISPONIBLE" }
      sample = apartment.sample
      expect(sample.nil?).to eq(false), 'No hay departamento maestro disponible.'
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
      expect(quote[:body]['error'].nil?).to eq(true), "Hubo un error al cotizar. Mensaje de error: #{quote[:body].to_s}"
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
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true), "Hubo un error al crear la reserva. Mensaje de error: #{response[:body].to_s}"
    end
  end
end

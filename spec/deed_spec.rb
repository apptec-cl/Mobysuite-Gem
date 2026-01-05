require 'mobysuite'

RSpec.describe Mobysuite::GC2::Deed do
  before do
    @deed = Mobysuite::GC2::Deed.new("try")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @deed.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Delivery Date' do
    it 'Create Delivery Date' do
      deed = @deed.delivery_date({id_erp: 123, date: Date.today.strftime("%Y-%m-%d")})
      expect(deed[:response]).to eq(true) 
    end
  end
end
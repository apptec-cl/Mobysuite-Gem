require 'mobysuite'
# require 'pry'

RSpec.describe Mobysuite::GC2::Opportunity do
  before do
    @opportunity = Mobysuite::GC2::Opportunity.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @opportunity.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Booking' do
    it 'Create Booking' do
      response = @opportunity.list()
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
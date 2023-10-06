require 'mobysuite'

RSpec.describe Mobysuite::GC2::Parameter do
  before do
    @parameter = Mobysuite::GC2::Parameter.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @parameter.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Parameter' do
    it 'List Commune' do
      response = @parameter.table("COMUNA")
      binding.pry
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
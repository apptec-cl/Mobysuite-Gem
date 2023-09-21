require 'mobysuite'

RSpec.describe Mobysuite::GC2::Asset do
  before do
    @asset = Mobysuite::GC2::Asset.new("demo2")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @asset.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end

  describe '#Assets' do
    it 'List' do
      binding.pry
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
end
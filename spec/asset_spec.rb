require 'mobysuite'

RSpec.describe Mobysuite::GC2::Asset do
  before do
    @asset = Mobysuite::GC2::Asset.new("try")
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
      response = @asset.list({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Types' do
      response = @asset.types({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'ClientAssetsProject' do
      response = @asset.client_assets_project({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Edit Asset' do
      response = @asset.edit({id_erp: 123, asset_status: "ENTREGADO"})
      p response
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
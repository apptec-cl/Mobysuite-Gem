require 'mobysuite'

RSpec.describe Mobysuite::GC2::Amc do
  before do
    @amc = Mobysuite::GC2::Amc.new("try")
  end

  describe '#AMC' do
    it 'Content' do
      response = @amc.content({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Document' do
      response = @amc.documents({contract_id: 1356})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end

    it 'Sidebar' do
      response = @amc.sidebar({project_id: 1})
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
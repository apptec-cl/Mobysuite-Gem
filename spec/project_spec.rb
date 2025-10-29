require 'mobysuite'

RSpec.describe Mobysuite::GC2::Project do
  before do
    @project = Mobysuite::GC2::Project.new("try")
  end

  describe '#Auth' do
    it 'Get Token' do
      response = @project.auth
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true)
    end
  end
  
  describe '#Projects' do
    it 'List' do
      response = @project.list()
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end
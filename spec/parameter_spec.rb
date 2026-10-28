require 'mobysuite'

RSpec.describe Mobysuite::GC2::Parameter, 'table routing' do
  let(:parameter) { described_class.allocate }
  let(:response) { { response: true, body: [] } }

  it 'preserves the integrations endpoint for table' do
    expect(parameter).to receive(:set_sender).with(
      'GET', 'integrations/parameters/table/COMUNA', 'COMUNA'
    ).and_return(response)

    expect(parameter.table('COMUNA')).to eq(response)
  end

  it 'uses the parameters endpoint when the filter is omitted' do
    expect(parameter).to receive(:set_sender).with(
      'GET', 'parameters/table/COMUNA', 'COMUNA'
    ).and_return(response)

    expect(parameter.table_with_filter('COMUNA')).to eq(response)
  end

  it 'omits the parent segment when the filter is nil' do
    expect(parameter).to receive(:set_sender).with(
      'GET', 'parameters/table/COMUNA', :COMUNA
    ).and_return(response)

    expect(parameter.table_with_filter(:COMUNA, nil)).to eq(response)
  end

  it 'appends the parent filter to the parameters endpoint' do
    expect(parameter).to receive(:set_sender).with(
      'GET', 'parameters/table/COMUNA/parent/13', 'COMUNA'
    ).and_return(response)

    expect(parameter.table_with_filter('COMUNA', 13)).to eq(response)
  end
end

RSpec.describe Mobysuite::GC2::Parameter do
  before do
    @parameter = Mobysuite::GC2::Parameter.new("try")
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
      expect(response).to be_a(Hash)
      expect(response[:response]).to eq(true) 
    end
  end
end

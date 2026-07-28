require 'mobysuite'

RSpec.describe AuthorizationGc2 do
  subject(:authorization) do
    described_class.new("try", "client-id", "protected-secret")
  end

  describe '#client_secret' do
    it 'does not expose the client secret publicly' do
      expect(authorization).not_to respond_to(:client_secret)
      expect { authorization.client_secret }.to raise_error(
        NoMethodError,
        /protected method [`']client_secret'/
      )
    end

    it 'does not allow the client secret to be changed publicly' do
      expect { authorization.client_secret = "new-secret" }.to raise_error(
        NoMethodError,
        /protected method [`']client_secret='/
      )
    end
  end
end

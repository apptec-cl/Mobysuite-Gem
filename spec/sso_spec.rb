require 'mobysuite'

RSpec.describe Mobysuite::GC2::Sso do
  describe '#sso_url' do
    it 'uses the test SSO in a Rails test environment' do
      rails = Module.new
      rails.define_singleton_method(:env) { "test" }
      stub_const("Rails", rails)

      sso = described_class.new("client-id", "client-secret")

      expect(sso.sso_url).to eq(described_class::TEST_URL)
    end

    it 'uses the production SSO in a Rails production environment' do
      rails = Module.new
      rails.define_singleton_method(:env) { "production" }
      stub_const("Rails", rails)

      sso = described_class.new("client-id", "client-secret")

      expect(sso.sso_url).to eq(described_class::PRODUCTION_URL)
    end
  end

  describe 'authentication and token validation' do
    it 'logs in with real credentials and validates the returned token' do
      rails = Module.new
      rails.define_singleton_method(:env) { "test" }
      stub_const("Rails", rails)

      customer = ENV.fetch("SSO_CUSTOMER")
      username = ENV.fetch("SSO_USERNAME")
      password = ENV.fetch("SSO_PASSWORD")
      sso = described_class.new
      login = sso.login(
        customer: customer,
        username: username,
        password: password
      )

      expect(login[:response]).to eq(true), "SSO login failed"
      expect(login[:body]).to be_a(Hash)

      token = login[:body]["access_token"] || login[:body]["accessToken"]
      expect(token).not_to be_nil

      validation = sso.validate_token(token, customer)

      expect(validation).to be_active
      expect(validation.claims["active"]).to eq(true)
      expect(validation.error).to be_nil
    end

    it 'does not expose the client secret or basic authorization publicly' do
      sso = described_class.new("client-id", "client-secret")

      expect(sso).not_to respond_to(:client_secret)
      expect(sso).not_to respond_to(:basic_auth)
    end
  end

  describe Mobysuite::GC2::Sso::TokenIntrospector do
    it 'rejects validation when the introspection endpoint is not configured' do
      introspector = described_class.new("")

      result = introspector.call("token", "app")

      expect(result).not_to be_active
      expect(result.error).to eq("sso_not_configured")
    end

    it 'rejects an inactive token' do
      response = instance_double(
        HTTParty::Response,
        success?: true,
        parsed_response: { "active" => false }
      )
      allow(HTTParty).to receive(:post).and_return(response)
      introspector = described_class.new(
        "https://sso-test.mobysuite.com/oauth/introspect"
      )

      result = introspector.call("token", "app")

      expect(result).not_to be_active
      expect(result.error).to eq("inactive_token")
    end
  end
end

require 'httparty'

class AuthorizationGc2
  include HTTParty
  require 'pry'

  NAMESPACE = "v1/api".freeze
  AUTH = ".mobysuite.com/oauth/token".freeze

  attr_accessor :headers, :domain, :client_id, :client_secret, :password, :grant_type, :token

  def initialize domain, client_id=nil, client_secret=nil, grant_type="client_credentials"
    self.domain        = domain
    self.client_id     = ENV["MOBYSUITE_GC2_CLIENT_ID"].empty? ? client_id : ENV["MOBYSUITE_GC2_CLIENT_ID"]
    self.client_secret = ENV["MOBYSUITE_GC2_CLIENT_SECRET"].empty? ? client_secret : ENV["MOBYSUITE_GC2_CLIENT_SECRET"] 
    self.token         = nil
    self.grant_type    = grant_type
    self.headers       = {}
  end

  def auth count=0
    response = HTTParty.post("https://#{self.domain}-api#{AUTH}",
      body: {client_id: self.client_id, client_secret: self.client_secret, grant_type: self.grant_type},
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      verify: false
    )
    unless response.success?
      count += 1
      return raise "[Autorization] Problem obtain token" if count > 3
    end
    self.token = response.parsed_response["accessToken"] if response.success?
    {token: response.parsed_response["accessToken"], response: response.success?}
  end

  def set_headers
    self.headers = {"Authorization": "Bearer #{self.token}", 'Content-Type': 'application/json'}
  end

  def define_response response
    case response.code
    when 200
      {response: true, body: response.parsed_response}
    when 201
      {response: true, body: response.parsed_response}
    when 401
      auth(1)
      {response: false, body: response.parsed_response, response_code: response.code}
    when 404, 500, 403, 400
      {response: false, body: response.parsed_response, response_code: response.code}
    else
      {response: false, body: response.parsed_response, response_code: response.code}
    end
  end

  def set_sender method, path, body
    case method
      when "GET"
        response = HTTParty.get("https://#{self.domain}-api.mobysuite.com/#{NAMESPACE}/#{path}", body: body, headers: self.set_headers , verify: false)
        define_response(response)
      when "POST"
        response = HTTParty.post("https://#{self.domain}-api.mobysuite.com/#{NAMESPACE}/#{path}", body: body.to_json, headers: self.set_headers , verify: false)
        define_response(response)
      when "PUT"
        response = HTTParty.put("https://#{self.domain}-api.mobysuite.com/#{NAMESPACE}/#{path}", body: body.to_json, headers: self.set_headers  , verify: false)
        define_response(response)
      end
  end
end
require 'httparty'
require 'pry'

class AuthorizationGc2

  include HTTParty

  NAMESPACE = "v1/api".freeze
  AUTH = ".mobysuite.com/oauth/token".freeze

  @@token_gc2_auth = ""

  attr_accessor :headers, :domain, :client_id, :client_secret, :password, :grant_type, :token

  def initialize domain, client_id=nil, client_secret=nil, grant_type="client_credentials"
    self.domain        = domain
    self.client_id     = ENV["MOBYSUITE_GC2_CLIENT_ID"].nil? ? client_id : ENV["MOBYSUITE_GC2_CLIENT_ID"]
    self.client_secret = ENV["MOBYSUITE_GC2_CLIENT_SECRET"].nil? ? client_secret : ENV["MOBYSUITE_GC2_CLIENT_SECRET"] 
    self.token         = nil
    self.grant_type    = grant_type
    self.headers       = {}
  end

  def auth count=0
    begin
      if @@token_gc2_auth.nil? || count != 0 || @@token_gc2_auth.length == 0
        response = HTTParty.post("https://#{self.domain}-api#{AUTH}",
          body: {client_id: self.client_id, client_secret: self.client_secret, grant_type: self.grant_type},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          verify: false
        )
        unless response.success?
          count += 1
          return raise "[Autorization] Problem obtain token" if count > 3
        end
        self.token       = response.parsed_response["accessToken"] if response.success?
        @@token_gc2_auth = self.token
        {token: response.parsed_response["accessToken"], response: response.success?}
      else
        self.token = @@token_gc2_auth
        {token: @@token_gc2_auth, response: true}
      end
    rescue => e
      {token: nil, response: false, msg: e}
    end
  end

  def is_auth?
    self.token.nil? ? false : true
  end

  def set_headers
    self.headers = {"Authorization": "Bearer #{self.token}", 'Content-Type': 'application/json'}
  end

  def define_response response
    case response.code
    when 200, 201
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

  def set_sender method, path, body = nil
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
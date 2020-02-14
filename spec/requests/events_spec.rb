require 'rails_helper'

RSpec.describe "Events", type: :request do
  user = Rails.application.credentials.get_token[:username].to_s
  pass = Rails.application.credentials.get_token[:password].to_s
  header_authorization = { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user, pass) }
  
  def header_secret(payload_body)
    { 'X-Hub-Signature' => 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
      Rails.application.credentials.github_secret[:sercret].to_s, payload_body.to_json) }
  end

  describe "GET /issues/:number/events" do
    it "when logged in and status code 200" do
      Event.create(number: 1, state: 'open')
      get "/issues/1/events", headers: header_authorization
      expect(response).to have_http_status(200)
    end

    it "when logged in and get all attributes correctly" do
      event = Event.create(number: 1, state: 'open')
      get "/issues/1/events", headers: header_authorization
      json = JSON.parse(response.body)[0]
      expect({
            id: event.id,
            number: event.number,
            state: event.state,
            created_at: I18n.l(event.created_at),
            updated_at: I18n.l(event.updated_at)}).to eq({
              id: json["id"],
              number: json["number"],
              state: json["state"],
              created_at: json["created_at"],
              updated_at: json["updated_at"]})
    end

    it "when not logged in" do
      Event.create(number: 1, state: 'open')
      get "/issues/1/events"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /issues/events" do
    it "when secret and params are correct" do
      payload_body = {issue: {number: 1, state: 'closed'}}
      post "/issues/events", headers: header_secret(payload_body), params: payload_body, as: :json
      expect(response).to have_http_status(201)
    end
  
    it "when state is different" do
      payload_body = {issue: {number: 1, state: 'doing'}}
      post "/issues/events", headers: header_secret(payload_body), params: payload_body, as: :json
      expect(response).to have_http_status(422)
    end

    it "when number is not a integer" do
      payload_body = {issue: {number: 'hello', state: 'doing'}}
      post "/issues/events", headers: header_secret(payload_body), params: payload_body, as: :json
      expect(response).to have_http_status(422)
    end

    it "when parameters are nil" do
      payload_body = {issue: {number: nil, state: nil}}
      post "/issues/events", headers: header_secret(payload_body), params: payload_body, as: :json
      expect(response).to have_http_status(422)
    end
  end
end

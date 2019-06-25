# frozen_string_literal: true

require "sinatra/base"

class FakeCredentialIssuerApi < Sinatra::Base
  post "/token" do
    return json_response 401, "token.json" unless params[:username] == "demo" && params[:password] == "demo"

    json_response 200, "token.json"
  end

  post "/authorizable_attribute/" do
    bearer = env.fetch("HTTP_AUTHORIZATION", "").slice(7..-1)
    return json_response 401, "authorizable_attribute.json" unless bearer == "demo.token"

    json_response 200, "authorizable_attribute.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + "/fixtures/credentials/" + file_name, "rb").read
  end
end

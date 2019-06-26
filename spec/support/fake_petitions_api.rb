# frozen_string_literal: true

require "sinatra/base"

class FakePetitionsApi < Sinatra::Base
  post "/token" do
    json_response 200, "token.json"
  end

  post "/petitions/" do
    json_response 200, "create.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + "/fixtures/petitions/" + file_name, "rb").read
  end
end

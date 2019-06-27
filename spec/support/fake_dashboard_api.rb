# frozen_string_literal: true

require "sinatra/base"

class FakeDashboardApi < Sinatra::Base
  post "/community/create_encrypted" do
    json_response 200, "create_encrypted.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + "/fixtures/dashboard/" + file_name, "rb").read
  end
end

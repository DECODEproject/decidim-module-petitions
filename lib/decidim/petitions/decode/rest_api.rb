# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      module RestApi
        include Decidim::Petitions::Decode::FileLogger

        ##
        # Runs a http request to authenticate using user and password
        # Params
        # url: URL of the authentication
        # username: Username to authenticate
        # password: Password to authenticate
        def authenticate(url: "", username: "", password: "")
          begin
            response = RestClient::Request.execute(
              method: :post,
              url: "#{url}/token",
              payload: "username=#{username}&password=#{password}"
            )
            logger_req(
              url: url,
              method: :post,
              payload: "username=#{username}&password=#{password}"
            )
            body = JSON.parse(response.body)
            status_code = response.code
          rescue RestClient::ExceptionWithResponse => err
            body = err.message
            status_code = err.http_code
          end
          logger_resp("API Call", response: body, status: status_code)
          { response: body, status_code: status_code }
        end

        # Call a given method on a path for some params with a bearer
        #
        def wrapper(method: :post, http_path: "", bearer: nil, params: {})
          begin
            response = response(method: method, url: http_path, bearer: bearer, params: params)
            body = JSON.parse(response.body)
            status_code = response.code
          rescue RestClient::ExceptionWithResponse => err
            body = err.message
            status_code = err.http_code
          end
          logger_resp("API Call", response: body, status: status_code)
          request = {
            url: http_path,
            method: method,
            params: params
          }

          { response: body, status_code: status_code, bearer: bearer, request: request }
        end

        private

        def response(method: :post, url: "", params: {}, bearer: nil)
          headers = {
            content_type: :json,
            accept: :json
          }
          headers = headers.merge(authorization: "Bearer #{bearer}") if bearer
          request = {
            url: url,
            method: :post,
            payload: params.to_json,
            headers: headers
          }
          logger_req(request)

           RestClient::Request.execute(
            method: method,
            url: url,
            payload: params.to_json,
            headers: headers
          )
        end
      end
    end
  end
end

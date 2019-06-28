# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      module Services
        class DDDCPetitionsAPI
          # Integration with https://github.com/DECODEproject/dddc-petition-api

          include RestApi

          def initialize(url: "", username: "", password: "")
            # login needs to be a hash with url, username and password
            # login = { url: "http://example.com", username: "demo", password: "demo"}
            @url = url
            @username = username
            @password = password
          end

          def create(petition_id: "", credential_issuer_url: "", credential_issuer_petition_value: "")
            # Creates the petition. Needs a valid Credential Issuer Authorizable Attribute.
            #
            auth = authenticate(url: @url, username: @username, password: @password)
            return auth unless auth[:status_code] == 200

            params = {
              petition_id: petition_id,
              credential_issuer_url: credential_issuer_url,
              credential_issuer_petition_value: credential_issuer_petition_value,
              authorizable_attribute_id: petition_id
            }

            wrapper(
              method: :post,
              http_path: "#{@url}/petitions/",
              bearer: auth[:response]["access_token"],
              params: params
            )
          end

          def tally(petition_id: "")
            # Tally the petition
            #
            auth = authenticate(url: @url, username: @username, password: @password)
            return auth unless auth[:status_code] == 200

            params = {
              authorizable_attribute_id: petition_id
            }

            wrapper(
              method: :post,
              http_path: "#{@url}/petitions/#{petition_id}/tally",
              bearer: auth[:response]["access_token"],
              params: params
            )
          end

          def count(petition_id: "")
            # Count the petition
            #

            auth = authenticate(url: @url, username: @username, password: @password)
            return auth unless auth[:status_code] == 200

            wrapper(
              method: :post,
              http_path: "#{@url}/petitions/#{petition_id}/count",
              bearer: auth[:response]["access_token"]
            )
          end

          def fetch(petition_id: "")
            # Get the petition with extended information
            #
            wrapper(
              method: :get,
              http_path: "#{@url}/petitions/#{petition_id}?expand=true"
            )
          end
        end
      end
    end
  end
end

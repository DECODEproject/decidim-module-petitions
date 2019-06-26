# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      module Services
        class DDDCCredentialIssuerAPI
          # Integration with https://github.com/DECODEproject/dddc-credential-issuer

          include Decidim::Petitions::Decode::RestApi

          def initialize(url: "", username: "", password: "")
            # login needs to be a hash with url, username and password
            # login = { url: "http://example.com", username: "demo", password: "demo"}
            @url = url
            @username = username
            @password = password
          end

          def create(hash_attributes: false,
                     reissuable: false,
                     attribute_id: "",
                     attribute_info: "",
                     attribute_info_optional: "")
            # Setup the Authorizable Attribute to Credential Issuer's API
            # If hash_attributes is true, then we hash the attribute_info with zenroom
            # If reissuable is true, then we send that configuration to Credential Issuer
            #
            auth = authenticate(url: @url, username: @username, password: @password)
            return auth unless auth[:status_code] == 200

            attribute_info = hash_attributes ? hash_attribute_info(attribute_info) : attribute_info
            attribute_info_optional = hash_attributes ? hash_attribute_info(attribute_info_optional) : attribute_info_optional
            params = { authorizable_attribute_id: attribute_id,
                       authorizable_attribute_info: attribute_info,
                       authorizable_attribute_info_optional: attribute_info_optional,
                       reissuable: reissuable }
            wrapper(
              method: :post,
              http_path: "#{@url}/authorizable_attribute/",
              params: params,
              bearer: auth[:response]["access_token"]
            )
          end

          def hash_attribute_info(attribute_info)
            # Recieves an attribute info with value_sets on plain text
            # and converts them with a hashing function from zenroom
            #
            logger "*" * 80
            logger "ATTR TO HASH => #{attribute_info} "
            output = attribute_info.map do |attribute|
              attribute["value_set"] = attribute["value_set"].map do |x|
                Decidim::Petitions::Decode::Zenroom.hashing(x)
              end
              attribute
            end
            logger "ATTR HASHED  => #{output} "
            logger "*" * 80
            output
          end

          def extract_first_attribute_info(attribute_info)
            # Given an attribute_info we delete all the value_sets except the first one (that's also hashed)
            # for being use with Petition API setup
            # input = [{"name"=>"codes", "type"=>"str", "value_set"=>["aaaaa", "bbbbb", "ccccc"]}]
            # output = [{"name"=>"codes", "type"=>"str", "value_set"=>["aaaaa"}]
            #
            logger "*" * 80
            logger "ATTR TO EXTRACT  => #{attribute_info} "
            attribute_info.map do |attribute|
              attribute["value_set"] = Decidim::Petitions::Decode::Zenroom.hashing(attribute["value_set"][0])
              attribute
            end
          end
        end
      end
    end
  end
end

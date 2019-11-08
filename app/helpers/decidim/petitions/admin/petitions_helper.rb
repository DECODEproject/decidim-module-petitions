# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      module PetitionsHelper

        def default_json_attribute_info
          # rubocop:disable Style/WordArray

          [{
            "name": "codes",
            "type": "str",
            "value_set": [
              "1234",
              "a_password"
            ]
          }]
        end

        def default_json_attribute_info_optional
          [
            {
              "k": 2,
              "name": "age",
              "type": "str",
              "value_set": ["0-19", "20-29", "30-39", ">40"]
            },
            {
              "k": 2,
              "name": "gender",
              "type": "str",
              "value_set": ["F", "M", "O"]
            },
            {
              "k": 2,
              "name": "district",
              "type": "str",
              "value_set": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
            }
          ]

          # rubocop:enable Style/WordArray
        end

        def default_json_schema
          credential_url = current_component.settings.credential_issuer_api_url
          petition_url = current_component.settings.petitions_api_url
          {
            "mandatory": [
              {
                "name": {
                  "ca": "Credencial per participar",
                  "en": "Credential to participate",
                  "es": "Credencial para participar"
                },
                "provenance": {
                  "url": "#{credential_url}",
                  "issuerName": {
                    "ca": "Gestor de credencials DECODE",
                    "en": "DECODE Credential Issuer",
                    "es": "Gestor de credenciales de DECODE"
                  },
                  "petitionsUrl": "#{petition_url}"
                },
                "verificationInput": [
                  {
                    "id": "codes",
                    "name": {
                      "ca": "Codi",
                      "en": "Code",
                      "es": "Código"
                    },
                    "type": "string"
                  }
                ]
              }
            ]
          }
        end
      end
    end
  end
end

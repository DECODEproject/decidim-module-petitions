# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class PetitionForm < Form
        include Decidim::TranslatableAttributes
        translatable_attribute :title, String
        translatable_attribute :summary, String
        translatable_attribute :description, String
        translatable_attribute :instructions_url, String
        attribute :image
        attribute :is_reissuable

        mimic :petition

        validates :title, :summary, :description, translatable_presence: true
        validates :json_schema, :json_attribute_info, :json_attribute_info_optional, presence: true
        validates :image, file_size: {
          less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size }
        }, file_content_type: { allow: ["image/jpeg", "image/png"] }

        def self.default_json_attribute_info
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

        def self.default_json_attribute_info_optional
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

        def self.default_json_schema
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
                  "url": "#{credential_issuer_api_url}",
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

        attribute :json_schema, SchemaAttribute, default: default_json_schema
        attribute :json_attribute_info_optional, SchemaAttribute, default: default_json_attribute_info_optional
        attribute :json_attribute_info, SchemaAttribute, default: default_json_attribute_info

      end
    end
  end
end

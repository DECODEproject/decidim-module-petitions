# frozen_string_literal: true
# rubocop:disable EnforcedStyle

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
        attribute :json_schema, SchemaAttribute, default: {
          "mandatory": [
            {
              "name": {
                "ca": "Credencial per participar",
                "en": "Credential to participate",
                "es": "Credencial para participar"
              },
              "provenance": {
                "url": "https://credential-test.dyne.org",
                "issuerName": {
                  "ca": "Gestor de credencials DECODE",
                  "en": "DECODE Credential Issuer",
                  "es": "Gestor de credenciales de DECODE"
                },
                "petitionsUrl": "https://petition-test.dyne.org"
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

        attribute :json_attribute_info, SchemaAttribute, default: [{
          "name": "codes",
          "type": "str",
          "value_set": [
            "1234",
            "a_password"
          ]
      }]

        attribute :json_attribute_info_optional, SchemaAttribute, default: [
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

        attribute :is_reissuable

        mimic :petition

        validates :title, :summary, :description, translatable_presence: true
        validates :json_schema, :json_attribute_info, :json_attribute_info_optional, presence: true
        validates :image, file_size: {
          less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size }
        }, file_content_type: { allow: ["image/jpeg", "image/png"] }
      end
    end
  end
end

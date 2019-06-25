# frozen_string_literal: true

module Decidim
  module Petitions
    module Faker
      def self.json_schema
        {
          mandatory: [
            {
              predicate: "schema:addressLocality",
              object: ::Faker::Address.state,
              scope: "can-access",
              provenance: {
                url: ::Faker::Internet.url
              }
            }
          ],
          optional: [
            {
              predicate: "schema:dateOfBirth",
              object: "voter",
              scope: "can-access"
            },
            {
              predicate: "schema:gender",
              object: "voter",
              scope: "can-access"
            }
          ]
        }
      end

      def self.json_attribute_info
        [
          {
            name: "codes",
            type: "str",
            value_set: Array.new(8) { SecureRandom.hex(3) }
          }
        ]
      end

      def self.json_attribute_info_optional
        [
          {
            k: 2,
            name: "age",
            type: "str",
            value_set: ["0-19", "20-29", "30-39", ">40"]
          },
          {
            k: 2,
            name: "gender",
            type: "str",
            value_set: %w(F M O)
          }
        ]
      end
    end
  end
end

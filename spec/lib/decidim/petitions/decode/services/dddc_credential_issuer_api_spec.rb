# frozen_string_literal: true

require "spec_helper"

describe Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI do
  context "when create work" do
    it ".hash_attribute_info work" do
      dddc_credentials = described_class.new("http://credentials.example.com")
      input = [
        {
          "name": "email",
          "type": "str",
          "value_set": [
            "andres@example.com"
          ]
        }, {
          "name": "zip_code",
          "type": "int",
          "value_set": %w(
            08001
            08002
          )
        }
      ]
      output = [
        {
          name: "email",
          type: "str",
          value_set: [
            "06bef662965b97a2a6ee233b89d3f22ce55a1cc9ac0b6d08c2951d6f30c7e59c1a54bcfb67ae87330c28a3834ce4b12e5b828fcb88742321ddad4dad81b9e036"
          ]
        }, {
          name: "zip_code",
          type: "int",
          value_set: %w(
            61d96ba82aa2368f51fbc79675b513f5ff8c14ecfb5fb946891e1bc909f47e4eaf2e16d59ec4774552dbda8951050a020b31c57687f8cc783e5ce63ee2b4fb6c
            713629bcec4a8e51543b4f9fa87015fdcd838ccf2ae184a546f422224469c6ad1f5ca5c850848437702136af9ec61c4ba02183e4f02a14bbbb918526c51ffb5b
          )
        }
      ]
      result = dddc_credentials.hash_attribute_info(input)
      expect(result).to eq output
    end
  end
end

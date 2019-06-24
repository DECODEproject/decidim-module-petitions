# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::CreatePetition do
    subject { described_class.new(form, current_user) }

    let(:organization) { create :organization }
    let(:participatory_process) { create :participatory_process, organization: organization }
    let(:invalid) { false }
    let(:current_component) { create :petitions_component, organization: organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:json_schema) do
      <<-JSON
      {
        "mandatory": [
          {
            "predicate": "schema:addressLocality",
            "object": "Barcelona",
            "scope": "can-access",
            "provenance": {
              "url": "http://example.com"
            }
          }
        ],
        "optional": [
          {
            "predicate": "schema:dateOfBirth",
            "object": "voter",
            "scope": "can-access"
          },
          {
            "predicate": "schema:gender",
            "object": "voter",
            "scope": "can-access"
          }
        ]
      }
      JSON
    end
    let(:json_attribute_info) do
      <<-JSON
      [
        {
          "name": "codes",
          "type": "str",
          "value_set": ["eih5O", "nuu3S", "Pha6x", "lahT4", "Ri3ex"]
        }
      ]
      JSON
    end
    let(:json_attribute_info_optional) do
      <<-JSON
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
          "value_set": ["1", "2", "3", "4", "5"]
        }
      ]
      JSON
    end

    let(:form) do
      double(
        invalid?: invalid,
        title: { en: "Foo title" },
        description: { en: "Foo description" },
        summary: { en: "Foo summary" },
        json_schema: json_schema,
        json_attribute_info: json_attribute_info,
        json_attribute_info_optional: json_attribute_info,
        author: current_user,
        image: nil,
        is_reissuable: false,
        instructions_url: nil,
        current_user: current_user,
        current_component: current_component,
        current_organization: organization
      )
    end

    describe "when everything is ok" do
      it "create the petition" do
        expect { subject.call }.to change(Petition, :count).by(1)
      end
    end

    describe "when the petition is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end

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
    let(:json_schema) { Faker.json_schema.to_json }
    let(:json_attribute_info) { Faker.json_attribute_info.to_json }
    let(:json_attribute_info_optional) { Faker.json_attribute_info_optional }

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

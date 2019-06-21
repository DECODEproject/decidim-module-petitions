# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"

FactoryBot.define do
  factory :petitions_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :petitions).i18n_name }
    manifest_name { :petitions }
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :petition, class: "Decidim::Petitions::Petition" do
    title { generate_localized_title }
    summary { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    author { build(:user, :confirmed, :admin, organization: component.organization) }
    component { build(:component, manifest_name: "petitions") }
    instructions_url { Faker::Internet.url }
    json_schema do
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
    end

    json_attribute_info do
      [
        {
          "name": "codes",
          "type": "str",
          value_set: %w(eih5O nuu3S Pha6x lahT4 Ri3ex Op2ii EG5th ca5Ca TuSh1 ut0iY Eing8 Iep1H yei2A ahf3I Oaf8f nai1H aib5V ohH5v eim2E Nah5l ooh5C Uqu3u Or2ei aF9fa ooc8W)
        }
      ]
    end

    json_attribute_info_optional do
      [
        {
          "name": "codes",
          "type": "str",
          value_set: %w(eih5O nuu3S Pha6x lahT4 Ri3ex Op2ii EG5th ca5Ca TuSh1 ut0iY Eing8 Iep1H yei2A ahf3I Oaf8f nai1H aib5V ohH5v eim2E Nah5l ooh5C Uqu3u Or2ei aF9fa ooc8W)
        }
      ]
    end

    trait :open do
      open { true }
    end
  end
end

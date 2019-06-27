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
    summary { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.paragraph(3) } }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.paragraph(5) } }
    author { build(:user, :confirmed, :admin, organization: component.organization) }
    component { build(:component, manifest_name: "petitions") }
    instructions_url { { en: ::Faker::Internet.url } }
    image { Decidim::Dev.test_file("city2.jpeg", "image/jpeg") }
    json_schema { Decidim::Petitions::Faker.json_schema }
    json_attribute_info { Decidim::Petitions::Faker.json_attribute_info }
    json_attribute_info_optional { Decidim::Petitions::Faker.json_attribute_info_optional }

    trait :open do
      open { true }
      state { "opened" }
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

shared_examples "manage petitions" do
  let(:json_schema) { Decidim::Petitions::Faker.json_schema }
  let(:json_attribute_info) { Decidim::Petitions::Faker.json_attribute_info }
  let(:json_attribute_info_optional) { Decidim::Petitions::Faker.json_attribute_info_optional }

  it "update a petition" do
    within find("tr", text: translated(petition.title)) do
      click_link "Edit"
    end

    within ".edit_petition" do
      fill_in_i18n(
        :petition_title,
        "#petition-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )
      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("The petition was updated successfully")

    within "table" do
      expect(page).to have_content("My new title")
    end
  end

  it "update invalid petition" do
    within find("tr", text: translated(petition.title)) do
      click_link "Edit"
    end

    within ".edit_petition" do
      fill_in :petition_json_schema, with: ""
    end

    find("*[type=submit]").click

    within ".edit_petition" do
      expect(page).to have_content("There's an error in this field.")
    end
  end

  it "create a new petition", :slow do
    find(".card-title a.button").click

    fill_in_i18n(
      :petition_title,
      "#petition-title-tabs",
      en: "My petition",
      es: "Mi petición",
      ca: "El meu petition"
    )

    fill_in_i18n_editor(
      :petition_summary,
      "#petition-summary-tabs",
      en: "Summary of my petition",
      es: "Summary mi petición",
      ca: "Summary el meu petition"
    )

    fill_in_i18n_editor(
      :petition_description,
      "#petition-description-tabs",
      en: "Description my petition",
      es: "Description mi petición",
      ca: "Description El meu petition"
    )

    fill_in_i18n(
      :petition_instructions_url,
      "#petition-instructions_url-tabs",
      en: "https://petition.example.org/en",
      es: "https://petition.example.org/es",
      ca: "https://petition.example.org/ca"
    )

    fill_in :petition_json_schema, with: json_schema.to_json
    fill_in :petition_json_attribute_info, with: json_attribute_info.to_json
    fill_in :petition_json_attribute_info_optional, with: json_attribute_info_optional.to_json

    within ".new_petition" do
      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("The petition was created successfully")
  end
end

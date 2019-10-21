# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:petitions) do |component|
  component.engine = Decidim::Petitions::Engine
  component.admin_engine = Decidim::Petitions::AdminEngine
  component.icon = "decidim/petitions/icon.svg"
  component.admin_stylesheet = "decidim/admin/petitions/petitions.css"

  component.permissions_class_name = "Decidim::Petitions::Permissions"

  component.settings(:global) do |settings|
    settings.attribute :credential_issuer_api_url, type: :string, default: "https://credentials.decodeproject.eu"
    settings.attribute :credential_issuer_api_user, type: :string, default: "", required: false
    settings.attribute :credential_issuer_api_pass, type: :string, default: "", required: false
    settings.attribute :petitions_api_url, type: :string, default: "https://petitions.decodeproject.eu"
    settings.attribute :petitions_api_user, type: :string, default: "", required: false
    settings.attribute :petitions_api_pass, type: :string, default: "", required: false
    settings.attribute :dashboard_api_url, type: :string, default: "https://dashboard.decodeproject.eu"
  end

  component.settings(:step) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
    settings.attribute :votes_enabled, type: :boolean
  end

  component.register_resource(:petition) do |resource|
    resource.model_class_name = "Decidim::Petitions::Petition"
    resource.card = "decidim/petitions/petition"
  end

  component.register_stat :petitions_count, primary: true, priority: Decidim::StatsRegistry::MEDIUM_PRIORITY do |components, _start_at, _end_at|
    Decidim::Petitions::Petition.where(component: components).count
  end

  component.seeds do |participatory_space|
    seeds_root = File.join(__dir__, "..", "..", "..", "db", "seeds")
    component = Decidim::Component.create!(
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :petitions).i18n_name,
      manifest_name: :petitions,
      published_at: Time.current,
      participatory_space: participatory_space
    )
    author = Decidim::User.where(organization: component.organization).all.first
    2.times do
      Decidim::Petitions::Petition.create!(
        component: component,
        title: Decidim::Faker::Localized.sentence(2),
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        summary: Decidim::Faker::Localized.paragraph(1),
        image: File.new(File.join(seeds_root, "petition.png")),
        author: author,
        json_schema: Decidim::Petitions::Faker.json_schema,
        json_attribute_info: Decidim::Petitions::Faker.json_attribute_info,
        json_attribute_info_optional: Decidim::Petitions::Faker.json_attribute_info_optional
      )
    end
  end
end

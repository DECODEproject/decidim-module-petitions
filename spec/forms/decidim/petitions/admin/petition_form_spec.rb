# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::PetitionForm do
    subject(:form) { described_class.from_params(attributes).with_context(context) }

    let(:organization) { create(:organization, available_locales: [:en]) }

    let(:context) do
      {
        current_organization: organization,
        current_component: current_component,
        current_participatory_space: participatory_process
      }
    end

    let(:participatory_process) { create :participatory_process, organization: organization }
    let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "petitions" }
    let(:author) { create(:user, :admin, organization: organization) }
    let(:json_schema) do
      {
        json: "true"
      }
    end

    let(:title) do
      Decidim::Faker::Localized.sentence(3)
    end
    let(:description) do
      Decidim::Faker::Localized.sentence(3)
    end
    let(:summary) do
      Decidim::Faker::Localized.sentence(3)
    end
    let(:attachment) { Decidim::Dev.test_file("city2.jpeg", "image/jpeg") }

    let(:attributes) do
      {
        title_en: title[:en],
        author: author,
        description_en: description[:en],
        summary_en: summary[:en],
        json_schema: json_schema,
        json_attribute_info: json_schema,
        json_attribute_info_optional: json_schema,
        image: attachment
      }
    end

    it { is_expected.to be_valid }

    describe "when title is missing" do
      let(:title) { { en: nil } }

      it { is_expected.not_to be_valid }
    end

    describe "when description is missing" do
      let(:description) { { en: nil } }

      it { is_expected.not_to be_valid }
    end

    describe "when summary is missing" do
      let(:summary) { { en: nil } }

      it { is_expected.not_to be_valid }
    end

    describe "when image size is greater than allowed" do
      before do
        allow(Decidim).to receive(:maximum_attachment_size).and_return(5.megabytes)
        expect(subject.image).to receive(:size).and_return(6.megabytes)
      end

      it { is_expected.not_to be_valid }
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe "User interact with petition", type: :system do
  include_context "with a component"
  let(:manifest_name) { "petitions" }

  let!(:component) { create(:petitions_component, manifest: manifest, participatory_space: participatory_space) }

  context "when listing petitions" do
    let!(:petitions) { create_list(:petition, 5, component: component) }

    it "show paginate buttons" do
      visit_component
      expect(page).to have_css(".card--petition", count: 4)
      expect(page).to have_css(".pagination .page", count: 2)
    end
  end

  context "when show a petition" do
    let!(:petition) { create(:petition, :open, component: component) }

    it "show the petition" do
      visit_component
      within find(".card--petition", text: translated(petition.title)) do
        click_link "Participate"
      end

      expect(page).to have_content("DESCRIPTION")
    end
  end
end

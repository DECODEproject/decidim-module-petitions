# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe PetitionMCell, type: :cell do
    controller Decidim::Petitions::PetitionsController

    let!(:petition) { create(:petition) }
    let(:model) { petition }
    let(:cell_html) { cell("decidim/petitions/petition_m", petition, context: { show_space: show_space }).call }

    let(:show_space) { false }

    it_behaves_like "has space in m-cell"

    it "renders the card" do
      expect(cell_html).to have_css(".warning")
      expect(cell_html).to have_css(".card__text--status", text: "Closed")
      expect(cell_html).to have_css(".card--petition")
      expect(cell_html).to have_css(".card__image")
    end

    context "when opened" do
      let(:petition) { create(:petition, :open) }

      it "renders opened petition" do
        expect(cell_html).to have_css(".success")
        expect(cell_html).to have_css(".card__text--status", text: "Open")
      end
    end
  end
end

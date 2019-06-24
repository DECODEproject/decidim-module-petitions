# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe PetitionCell, type: :cell do
    controller Decidim::Petitions::PetitionsController

    let!(:petition) { create(:petition) }
    let(:card_html) { cell("decidim/petitions/petition", petition).call }

    context "when rendering" do
      it "renders the card" do
        expect(card_html).to have_css(".card--petition")
      end
    end
  end
end

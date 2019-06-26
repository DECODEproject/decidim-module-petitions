# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe PetitionsHelper do
    let(:petition) { create(:petition) }

    describe "petition_qrcode" do
      it "generate a qrcode" do
        expect(helper.petition_qrcode(petition)).to start_with "data:image/png;base64,"
      end
    end

    describe "decodewallet_button" do
      it "generate link to decode wallet" do
        expect(helper.decodewallet_button(petition)).to have_css(".button--sc")
      end
    end

    describe "expo_button" do
      it "generate link to expo" do
        expect(helper.expo_button(petition)).to have_css(".button--sc")
      end
    end
  end
end

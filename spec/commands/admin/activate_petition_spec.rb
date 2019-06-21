# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::ActivatePetition do
    subject { described_class.new(petition) }

    let(:petition) { create :petition }

    context "when everything is ok" do
      it "activate the petition" do
        subject.call

        expect(petition.open).to eq true
      end

      it "broadcast ok" do
        expect { subject.call }.to broadcast(:ok)
      end
    end
  end
end

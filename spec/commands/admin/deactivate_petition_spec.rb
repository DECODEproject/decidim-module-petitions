# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::DeactivatePetition do
    subject { described_class.new(petition) }

    let(:petition) { create :petition, :open }

    context "when everything is ok" do
      it "deactivate the petition" do
        subject.call

        expect(petition.open).to eq false
      end

      it "broadcast ok" do
        expect { subject.call }.to broadcast(:ok)
      end
    end
  end
end

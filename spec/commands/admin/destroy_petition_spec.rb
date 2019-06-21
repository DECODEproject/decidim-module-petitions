# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::DestroyPetition do
    subject { described_class.new(petition) }

    let(:petition) { create :petition }

    context "when everything is ok" do
      it "destroy the petition" do
        subject.call

        expect { petition.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "broadcast ok" do
        expect { subject.call }.to broadcast(:ok)
      end
    end
  end
end

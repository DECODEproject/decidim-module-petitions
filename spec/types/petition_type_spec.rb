# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim::Petitions
  describe PetitionType do
    include_context "with a graphql type"

    let(:model) { create(:petition) }

    describe "id" do
      let(:query) { "{ id }" }

      it "returns the petition uuid" do
        expect(response).to include("id" => model.id)
      end
    end

    describe "credential_issuer_url" do
      let(:query) { "{ credential_issuer_api_url }" }

      it "returns the component credential_issuer_api_url" do
        expect(response).to include("credential_issuer_api_url" => model.component.settings.credential_issuer_api_url)
      end
    end
  end
end

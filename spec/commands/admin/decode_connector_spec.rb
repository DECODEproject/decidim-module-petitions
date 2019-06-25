# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe Admin::DecodeConnector do
    subject { described_class.new(petition, command) }

    let(:component) { create(:petitions_component, settings: settings) }
    let(:petition) { create(:petition, component: component) }
    let(:settings) do
      {
        credential_issuer_api_user: credential_user,
        credential_issuer_api_pass: credential_pass
      }
    end

    let(:credential_user) { "demo" }
    let(:credential_pass) { "demo" }

    describe "with credential issuer" do
      before do
        stub_request(:any, /credentials/).to_rack(FakeCredentialIssuerApi)
      end

      let(:command) { "credential_issuer" }

      it "get the credentials" do
        expect(subject.call).to broadcast(:ok)
      end

      context "when authentication failed" do
        let(:credential_user) { "dummy" }

        it { expect(subject.call).to broadcast(:invalid) }
      end
    end
  end
end

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

    describe "with petitions api" do
      before do
        stub_request(:any, /petitions/).to_rack(FakePetitionsApi)
      end

      context "with create_petitions" do
        let(:command) { "create_petition" }

        it { expect(subject.call).to broadcast(:ok) }
      end

      context "with get petition" do
        let(:command) { "get_petition" }

        it { expect(subject.call).to broadcast(:ok) }
      end

      context "with tally petition" do
        let(:command) { "tally_petition" }

        it { expect(subject.call).to broadcast(:ok) }
      end

      context "with count petition" do
        let(:command) { "count_petition" }

        it "update the vote count" do
          expect(subject.call).to broadcast(:ok)
          expect(petition.votes).to eq(125)
        end
      end

    end

    describe "with barcelona dashboard" do
      before do
        stub_request(:any, /dashboard/).to_rack(FakeDashboardApi)
      end

      let(:command) { "barcelona_now_dashboard" }

      it "setup barcelona now" do
        expect(subject.call).to broadcast(:ok)
      end
    end
  end
end

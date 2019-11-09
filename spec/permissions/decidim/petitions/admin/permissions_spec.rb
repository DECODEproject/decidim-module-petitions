# frozen_string_literal: true

require "spec_helper"

describe Decidim::Petitions::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :user, :admin, organization: organization }
  let(:organization) { create :organization }
  let(:component) { create :petitions_component, organization: organization }
  let(:petition) { create :petition, author: user, component: component }
  let(:context) { { petition: petition }.merge(extra_context) }
  let(:extra_context) { {} }

  let(:action) do
    { scope: :admin, action: action_name, subject: action_subject }
  end

  let(:permission_action) { Decidim::PermissionAction.new(action) }

  context "when the action is not for the admin part" do
    let(:action) do
      { scope: :public, action: :foo, subject: :bar }
    end

    it_behaves_like "permission is not set"
  end

  context "when the user is not an admin" do
    let(:user) { create :user, organization: organization }
    let(:action) do
      { scope: :admin, action: :foo, subject: :bar }
    end

    it "deny permission" do
      expect(subject).to eq false
    end
  end

  describe "petitions" do
    let(:action_subject) { :petition }

    context "when creating a petition" do
      let(:action_name) { :create }

      it { expect(subject).to eq true }
    end
  end
end

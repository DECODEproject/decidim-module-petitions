# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Petitions
    module Admin
      describe Permissions do
        subject { described_class.new(user, permission_action, context).permissions.allowed? }

        let(:component) { create :petitions_component }
        let(:user) { create :user, :admin, organization: component.organization }
        let(:petition) { create :petition, author: user, component: component }
        let(:context) { { petition: petition }.merge(extra_context) }
        let(:extra_context) { {} }

        let(:action) do
          { scope: :admin, action: action_name, subject: action_subject }
        end

        let(:permission_action) { Decidim::PermissionAction.new(action) }

        context "when the user is not an admin" do
          let(:user) { create :user, organization: component.organization }
          let(:action) do
            { scope: :admin, action: :foo, subject: :bar }
          end

          it { is_expected.to eq false }
        end

        describe "petitions" do
          let(:action_subject) { :petition }

          context "when creating a petition" do
            let(:action_name) { :create }

            it { is_expected.to eq true }
          end
        end
      end
    end
  end
end

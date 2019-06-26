# frozen_string_literal: true

require "spec_helper"

module Decidim::Petitions
  describe PetitionsController, type: :controller do
    routes { Decidim::Petitions::Engine.routes }

    let(:component) { create(:petitions_component) }
    let(:user) { create :user, :confirmed, organization: component.organization }
    let(:params) { { component_id: component.id } }
    let(:petition) { create :petition, :open, component: component }

    before do
      request.env["decidim.current_organization"] = component.organization
      request.env["decidim.current_participatory_space"] = component.participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
    end

    describe "GET index" do
      it "render index" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "SHOW petition" do
      let(:params) do
        {
          participatory_process_slug: component.participatory_space.slug,
          component_id: component.id,
          id: petition.id
        }
      end

      it "render a petition" do
        get :show, params: params
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end
    end
  end
end

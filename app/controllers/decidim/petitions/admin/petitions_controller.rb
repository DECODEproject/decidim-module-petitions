# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class PetitionsController < Admin::ApplicationController
        def new
          enforce_permission_to :create, :petition
          @form = form(PetitionForm).instance
        end

        def create
          enforce_permission_to :create, :petition
          @form = form(PetitionForm).from_params(params, current_component: current_component)

          CreatePetition.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.create.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("petitions.create.invalid", scope: "decidim.petitions.admin")
              render action: "new"
            end
          end
        end

        def edit
          enforce_permission_to :update, :petition, petition: petition
          @form = form(PetitionForm).from_model(petition)
        end

        def update
          enforce_permission_to :update, :petition, petition: petition
          @form = form(PetitionForm).from_params(params, current_component: current_component)

          UpdatePetition.call(petition, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.update.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("petitions.update.invalid", scope: "decidim.petitions.admin")
              render action: "edit"
            end
          end
        end

        %w(destroy activate deactivate).each do |method|
          define_method :"#{method}" do
            "Decidim::Petitions::Admin::#{method.capitalize}Petition".constantize.call(petition) do
              enforce_permission_to :manage, :petition, petition: petition
              on(:ok) do
                flash[:notice] = I18n.t("petitions.#{method}.success", scope: "decidim.petitions.admin")
                redirect_to petitions_path
              end
            end
          end
        end

        def decode
          # Executes command on DECODE to different APIs
          #
          enforce_permission_to :update, :petition, petition: petition
          DecodeConnector.call(petition, params[:command]) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.decode.success.#{params[:command]}", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
            on(:invalid) do |result|
              flash[:error] = I18n.t("petitions.decode.invalid.#{result[:status_code]}",
                                     scope: "decidim.petitions.admin")
              flash[:debug] = I18n.t("petitions.decode.invalid.debug",
                                     response: result[:response],
                                     status_code: result[:status_code],
                                     scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
          end
        end

        private

        def petition
          @petition ||= Petition.find_by(component: current_component, id: params[:id])
        end
      end
    end
  end
end

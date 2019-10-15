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
            on(:ok) do |result|
              flash[:notice] = I18n.t("petitions.decode.success.#{params[:command]}", scope: "decidim.petitions.admin")
              update_log(result)
            end
            on(:invalid) do |result|
              flash[:error] = I18n.t("petitions.decode.invalid.#{result[:status_code]}",
                                     scope: "decidim.petitions.admin")
              update_log(result)
            end
          end
        end

        private

        def petition
          @petition ||= Petition.find_by(component: current_component, id: params[:id])
        end

        def update_log(result)
          petition_log = <<~LOG_TEXT
            AUTHENTICATION
            ================================
            #{result[:bearer]}
            ================================
            URL
            ================================
            #{result[:request][:url]}
            ================================
            METHOD
            ================================
            #{result[:request][:method]}
            ================================
            PARAMS
            ================================
            #{JSON.pretty_generate(result[:request][:params])}
            ================================
            STATUS CODE
            ================================
            #{result[:status_code]}
            ================================
            RESPONSE
            ================================
            #{result[:response]}
            ================================
          LOG_TEXT
          petition.update log: petition_log.strip
        end
      end
    end
  end
end

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
              if result.has_key? :output
                update_cmd_log(result, params[:command].to_sym => true)
              else
                update_http_log(result, params[:command].to_sym => true)
              end
            end
            on(:invalid) do |result|
              flash[:error] = I18n.t("petitions.decode.invalid.#{result[:status_code]}",
                                     scope: "decidim.petitions.admin")
              if result.has_key? :output
                update_cmd_log(result, params[:command].to_sym => false)
              else
                update_http_log(result, params[:command].to_sym => false)
              end
            end
          end
        end

        private

        def petition
          @petition ||= Petition.find_by(component: current_component, id: params[:id])
        end

        def update_cmd_log(result, status)
          result_check = result[:api_result][:response]["results"] == JSON.parse(result[:output][:stdout])["results"]
          petition_log = <<~LOG_TEXT
            RESULT CHECK
            ================================
            #{result_check}
            ================================
            ZENROOM COMMAND OUTPUT
            ================================
            #{result[:output][:stderr].encode('iso-8859-1').encode('utf-8')}
            ================================
            PETITIONS API /count RESPONSE
            ================================
            #{result[:api_result][:response].to_json}
            ================================
            EXTRA DEBUG INFORMATION
            ================================
            TALLY DATA
            ================================
            #{JSON.pretty_generate(result[:output][:data][:tally])}
            ================================
            PETITION DATA
            ================================
            #{JSON.pretty_generate(result[:output][:data][:petition])}
          LOG_TEXT
          decode_status = petition.status.merge(status)
          petition.update_attributes(
            log: petition_log.strip,
            status: decode_status
          )
        end

        def update_http_log(result, status)
          petition_log = <<~LOG_TEXT
            CURL
            ================================
            curl -X #{result[:request][:method].upcase} "#{result[:request][:url]}" -H  "accept: application/json" \\
            -H  "Authorization: Bearer #{result[:bearer]}" \\
            -H  "Content-Type: application/json" \\
            -d #{result[:request][:params].to_json.inspect}
            ===============================
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
          decode_status = petition.status.merge(status)
          petition.update_attributes(
            log: petition_log.strip,
            status: decode_status,
            json_attribute_info: petition.json_attribute_info_was,
            json_attribute_info_optional: petition.json_attribute_info_optional_was
          )
        end
      end
    end
  end
end

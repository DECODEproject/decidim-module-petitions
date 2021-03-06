# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      class Connector
        def initialize(petition)
          @petition = petition
        end

        def setup_dddc_credentials
          Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            settings_credentials_issuer_api
          ).create(
            attribute_id: petition.attribute_id,
            attribute_info: petition.json_attribute_info,
            attribute_info_optional: petition.json_attribute_info_optional,
            reissuable: petition.is_reissuable
          )
        end

        def setup_barcelona_now
          Decidim::Petitions::Decode::Services::BarcelonaNow.new(
            settings_dashboard_api
          ).create(
            authorizable_attribute_id: petition.attribute_id,
            community_id: petition.attribute_id,
            community_name: petition.community_name,
            credential_issuer_endpoint_address: petition.component.settings.credential_issuer_api_url
          )
        end

        def fetch_dddc_petition
          dddc_petitions.fetch(
            petition_id: petition.attribute_id
          )
        end

        def create_dddc_petition
          dddc_petitions.create(
            petition_id: petition.attribute_id,
            credential_issuer_url: petition.component.settings.credential_issuer_api_url,
            credential_issuer_petition_value: petition_value
          )
        end

        def tally_dddc_petition
          dddc_petitions.tally(
            petition_id: petition.attribute_id
          )
        end

        def count_dddc_petition
          dddc_petitions.count(
            petition_id: petition.attribute_id
          )
        end

        def assert_count_dddc_petition
          api_result = fetch_dddc_petition
          Decidim::Petitions::Decode::Zenroom.count_petition(
            json_tally: api_result[:response]["tally"],
            json_petition: api_result[:response]["petition"]
          )
        end

        private

        attr_reader :petition

        def dddc_petitions
          Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            settings_petitions_api
          )
        end

        def settings_credentials_issuer_api
          {
            url: petition.component.settings.credential_issuer_api_url,
            username: petition.component.settings.credential_issuer_api_user,
            password: petition.component.settings.credential_issuer_api_pass
          }
        end

        def settings_dashboard_api
          {
            url: petition.component.settings.dashboard_api_url
          }
        end

        def settings_petitions_api
          {
            url: petition.component.settings.petitions_api_url,
            username: petition.component.settings.petitions_api_user,
            password: petition.component.settings.petitions_api_pass
          }
        end

        def petition_value
          Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            settings_credentials_issuer_api
          ).extract_first_attribute_info(petition.json_attribute_info).map { |k| { name: k["name"], value: k["value_set"] } }
        end
      end
    end
  end
end

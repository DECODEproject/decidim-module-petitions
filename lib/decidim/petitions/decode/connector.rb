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
            hash_attributes: true,
            reissuable: petition.is_reissuable,
            attribute_id: petition.attribute_id,
            attribute_info: petition.json_attribute_info,
            attribute_info_optional: petition.json_attribute_info_optional
          )
        rescue Errno::EADDRNOTAVAIL
          { status_code: 500 }
        rescue RestClient::UnprocessableEntity
          { status_code: 422 }
        end

        def setup_barcelona_now
          Decidim::Petitions::Decode::Services::BarcelonaNow.new(
            settings_dashboard_api
          ).create(
            credential_issuer_url: settings_credentials_issuer_api.url,
            community_name: @petition.community_name,
            community_id: @petition.community_id,
            attribute_id: @petition.attribute_id
          )
        end

        def fetch_dddc_petitions
          dddc_petitions.get(
            petition_id: @petition.attribute_id
          )
        end

        def create_dddc_petition
          dddc_petitions.create(
            petition_id: @petition.attribute_id,
            credential_issuer_url: settings_credentials_issuer_api.url,
            credential_issuer_petition_value: petition_value
          )
        end

        def tally_dddc_petitions
          dddc_petitions.tally(
            petition_id: @petition.attribute_id
          )
        end

        def count_dddc_petitions
          dddc_petitions.count(
            petition_id: @petition.attribute_id
          )
        end

        def assert_count_dddc_petitions
          api_result = fetch_dddc_petitions
          json_result = JSON.parse(api_result[:response])
          Decidim::Petitions::Decode::Zenroom.count_petition(
            json_tally: json_result["tally"],
            json_petition: json_result["petition"]
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
            url: @component.settings.barcelona_now_api_url
          }
        end

        def settings_petitions_api
          {
            url: @component.settings.petitions_api_url,
            user: @component.settings.petitions_api_user,
            password: @component.settings.petitions_api_pass
          }
        end

        def petition_value
          Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            settings_credentials_issuer_api
          ).extract_first_attribute_info(@petition.json_attribute_info)
        end
      end
    end
  end
end

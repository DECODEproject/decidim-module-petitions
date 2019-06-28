# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class DecodeConnector < Rectify::Command
        def initialize(petition, command)
          @petition = petition
          @command = command
          @connector = Decidim::Petitions::Decode::Connector.new(petition)
        end

        def call
          result = decode_command
          return broadcast(:invalid, result) unless result[:status_code] == 200

          broadcast(:ok, result)
        end

        private

        attr_reader :petition, :command, :connector

        def decode_command
          # Wrapper for decode commands
          # Every command corresponds with an action on a DECODE service
          # It should always responds with a { status_code: XX } at least
          # Could also have { status_code: XX, response: "YYY" }
          #
          send(command)
        end

        def credential_issuer
          connector.setup_dddc_credentials
        end

        def barcelona_now_dashboard
          connector.setup_barcelona_now
        end

        def create_petition
          connector.create_dddc_petition
        end

        def get_petition
          connector.get_dddc_petition
        end

        def tally_petition
          connector.tally_dddc_petition
        end

        def count_petition
          result = connector.count_dddc_petition
          if result[:status_code] == 200
            votes = result[:response]["result"]
            petition.update_attribute(:votes, votes)
          end
          result
        end

        def assert_count
          response = @connector.assert_count_dddc_petitions
          api_result = @connector.count_dddc_petitions
          flash[:info] = "
            Zenroom response = #{response} |||
            Petitions API Count = #{api_result[:response]}  |||
            Results = #{response == api_result[:response]}
          "
          { status_code: 200 }
        end
      end
    end
  end
end

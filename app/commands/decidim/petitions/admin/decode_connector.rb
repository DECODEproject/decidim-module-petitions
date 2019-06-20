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
          decode_command
          broadcast(:ok) if flash[:error].nil? && flash[:warning].nil?
        end

        private

        attr_reader :petition

        def decode_command
          # Wrapper for decode commands
          # Every command corresponds with an action on a DECODE service
          # It should always responds with a { status_code: XX } at least
          # Could also have { status_code: XX, response: "YYY" }
          #
          result = send(@command)
          unless result[:status_code] == 200
            # Status Code 409 is Conflict, as in "there's already that content on the API"
            flash[:warning] = t(".duplicated.#{@command}", status_code: result[:status_code]) if result[:status_code] == 409
            flash[:error] = t(".errors.#{@command}", status_code: result[:status_code])
          end
        end

        def credential_issuer
          @connector.setup_dddc_credentials
        end

        def barcelona_now_dashboard
          @connector.setup_barcelona_now
        end

        def petitions
          @connector.setup_dddc_petitions
        end

        def get
          @connector.get_dddc_petitions
        end

        def tally
          @connector.tally_dddc_petitions
        end

        def count
          result = @connector.count_dddc_petitions
          votes = JSON.parse(result[:response])["result"]
          petition.update_attribute(:votes, votes)
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

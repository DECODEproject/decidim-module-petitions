# frozen_string_literal: true

require "logger"

module Decidim
  module Petitions
    module Decode
      module FileLogger
        def decode_logger
          @decode_logger ||= Logger.new("#{Rails.root}/log/decode.log")
        end

        def logger(message)
          # Log with Rails.logger or just to stdout for Heroku
          #
          if ENV["RAILS_LOG_TO_STDOUT"]&.present?
            Rails.logger.info("DDDC-API -> #{message}")
          else
            decode_logger.info(message)
          end
        end

        def logger_resp(message, response: nil, status: nil)
          # Log rest-client responses
          #
          logger("-" * 80)
          logger(message + " - response")
          logger "STATUS CODE => #{status}"
          logger "BODY        => #{response}"
          logger("*" * 80)
        end

        def logger_req(url: nil, method: :post, payload: nil, headers: nil)
          logger("-" * 80)
          logger("API Request")
          logger("URL: #{url}")
          logger("Method: #{method}")
          logger("Headers: #{headers}")
          logger("Payload: #{payload}")
          logger("-" * 80)
        end
      end
    end
  end
end

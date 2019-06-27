# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      module Services
        class BarcelonaNow
          # Integration with https://github.com/DECODEproject/bcnnow

          include RestApi

          def initialize(url: nil)
            # login needs to be a hash with url
            # login = { url: "http://example.com" }
            @url = url
          end

          def create(params)
            # Setup the Barcelona Now Dashboard API
            #
            wrapper(
              method: :post,
              http_path: "#{url}/community/create_encrypted",
              params: params
            )
          end

          private

          attr_reader :url
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Petitions
    module Decode
      autoload :FileLogger, "decidim/petitions/decode/file_logger"
      autoload :Connector, "decidim/petitions/decode/connector"
      autoload :RestApi, "decidim/petitions/decode/rest_api"
      autoload :Zenroom, "decidim/petitions/decode/zenroom"
      autoload :Services, "decidim/petitions/decode/services"
    end
  end
end

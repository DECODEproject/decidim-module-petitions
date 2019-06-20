# frozen_string_literal: true


module Decidim
  module Petitions
    module Decode
      module Services
        autoload :BarcelonaNow, "decidim/petitions/decode/services/barcelona_now"
        autoload :DDDCCredentialIssuerAPI, "decidim/petitions/decode/services/dddc_credential_issuer_api"
        autoload :DDDCPetitionsAPI, "decidim/petitions/decode/services/dddc_petitions_api"
      end
    end
  end
end

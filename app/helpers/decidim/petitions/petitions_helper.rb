# frozen_string_literal: true

require "rqrcode"

module Decidim
  module Petitions
    module PetitionsHelper
      include Decidim::ApplicationHelper
      include Decidim::TranslationsHelper
      include Decidim::ResourceHelper

      def decodewallet_button(petition)
        link_to t("open_wallet", scope: "decidim.petitions.petitions.petition"), decode_url(petition), class: "button expanded button--sc"
      end

      def petition_qrcode(petition)
        "data:image/png;base64," + Base64.strict_encode64(RQRCode::QRCode.new(decode_url(petition)).as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: "white",
          color: "black",
          size: 280,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
        ).to_s)
      end

      private

      def support_url(petition)
        "support"\
        "?decidimAPIUrl=#{decidim_api.root_url}"\
        "&serviceId=#{petition.id}"\
        "&credentialIssuerEndpointAddress=#{credential_issuer(petition)}"\
        "&authorizableAttributeId=#{petition.attribute_id}"
      end

      def decode_url(petition)
        "decodeapp://#{support_url(petition)}"
      end

      def credential_issuer(petition)
        petition.component.settings.credential_issuer_api_url
      end

      def callback(petition)
        petition.component.settings.dashboard_api_url
      end
    end
  end
end

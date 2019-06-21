# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Petitions
    class SchemaAttribute < Virtus::Attribute
      def coerce(value)
        value.is_a?(::Hash) || value.is_a?(::Array) ? value : JSON.parse(value)
      end
    end
  end
end

# frozen_string_literal: true

require "decidim/petitions/admin"
require "decidim/petitions/engine"
require "decidim/petitions/admin_engine"
require "decidim/petitions/component"

module Decidim
  # This namespace holds the logic of the `Petitions` component. This component
  # allows users to create petitions in a participatory space.
  module Petitions
    autoload :Decode, "decidim/petitions/decode"
    autoload :Faker, "decidim/petitions/faker"
    autoload :QueryExtensions, "decidim/petitions/query_extensions"
    autoload :SchemaAttribute, "decidim/petitions/schema_attribute"
    autoload :ViewModel, "decidim/petitions/view_model"
  end
end

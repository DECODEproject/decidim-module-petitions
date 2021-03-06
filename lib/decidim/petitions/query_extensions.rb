# frozen_string_literal: true

# :nocov:
module Decidim
  module Petitions
    module QueryExtensions
      def self.define(type)
        type.field :petition do
          type PetitionType

          argument :id, !types.ID, "The petition ID"

          resolve lambda { |_obj, args, ctx|
            petition = Petition.find_by(id: args[:id])
            return nil unless petition&.organization == ctx[:current_organization]
            petition
          }
        end

        type.field :petitions do
          type types[PetitionType]
          resolve lambda { |_obj, _args, ctx|
            Petition.all.select do |petition|
              petition.organization == ctx[:current_organization]
            end
          }
        end
      end
    end
  end
end
# :nocov:

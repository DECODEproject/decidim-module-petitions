# frozen_string_literal: true

module Decidim
  module Petitions
    module QueryExtensions
      def self.define(type)
        type.field :petition do
          type !PetitionType

          argument :id, !types.ID, "The petition ID"

          resolve lambda { |_obj, args, _ctx|
            Petition.find_by(id: args[:id])
          }
        end

        type.field :petitions do
          type types[PetitionType]
          resolve lambda { |_obj, _args, _ctx|
            Petition.all
          }
        end
      end
    end
  end
end

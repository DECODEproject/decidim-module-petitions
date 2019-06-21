# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class UpdatePetition < Rectify::Command
        def initialize(petition, form)
          @form = form
          @petition = petition
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_petition

          if petition.valid?
            broadcast(:ok, petition)
          else
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :petition

        def update_petition
          petition.assign_attributes(attributes)
          petition.save! if petition.valid?
        end

        def attributes
          {
            title: form.title,
            summary: form.summary,
            description: form.description,
            image: form.image,
            json_schema: form.json_schema,
            json_attribute_info: form.json_attribute_info,
            json_attribute_info_optional: form.json_attribute_info_optional,
            is_reissuable: form.is_reissuable,
            instructions_url: form.instructions_url
          }
        end
      end
    end
  end
end

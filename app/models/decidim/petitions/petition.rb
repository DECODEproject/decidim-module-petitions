# frozen_string_literal: true

module Decidim
  module Petitions
    class Petition < Petitions::ApplicationRecord
      include Decidim::Authorable
      include Decidim::HasComponent
      include Decidim::Publicable
      include Decidim::Resourceable

      mount_uploader :image, Decidim::Petitions::ImageUploader

      validates :title, :description, :summary, presence: true
      validate :author_belong_to_organization

      scope :closed, -> { where(state: "closed") }
      scope :opened, -> { where(state: "opened") }

      def body
        title
      end

      def community_name
        title["en"]
      end

      def attribute_uuid
        # A method to make tests editing the title
        # It's unique to this Decidim installation 
        (Decidim.config.application_name + "-" + title["en"]).downcase.gsub(' ', '-')
      end

      def closed?
        state == "closed"
      end

      def opened?
        state == "opened"
      end

      private

      def author_belong_to_organization
        return if !author || !organization

        errors.add(:author, :invalid) unless author.organization == organization
      end
    end
  end
end

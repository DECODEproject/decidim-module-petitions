# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action unless user
          return permission_action unless permission_action.scope == :admin

          return permission_action if petition && !petition.is_a?(Decidim::Petitions::Petition)

          unless user.admin?
            disallow!
            return permission_action
          end

          allow!
          permission_action
        end

        private

        def petition
          @petition ||= context.fetch(:petition, nil)
        end
      end
    end
  end
end

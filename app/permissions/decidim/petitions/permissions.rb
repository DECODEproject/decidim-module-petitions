# frozen_string_literal: true

module Decidim
  module Petitions
    class Permissions < Decidim::DefaultPermissions
      def permissions
        if permission_action.scope == :public
          allow!
          return permission_action
        end

        return Decidim::Consultations::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        permission_action
      end
    end
  end
end

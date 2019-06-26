# frozen_string_literal: true

module Decidim
  module Petitions
    class Permissions < Decidim::DefaultPermissions
      def permissions
        if permission_action.scope == :public
          allow!
          return permission_action
        end

        return Decidim::Petitions::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
      end
    end
  end
end

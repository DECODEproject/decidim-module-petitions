# frozen_string_literal: true

class AddUserGroupIdToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :decidim_user_group_id, :integer
  end
end

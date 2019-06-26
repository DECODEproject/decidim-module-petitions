# frozen_string_literal: true

class AddImageToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :image, :string
  end
end

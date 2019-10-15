class AddLogToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :log, :text
  end
end

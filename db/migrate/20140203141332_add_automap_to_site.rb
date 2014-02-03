class AddAutomapToSite < ActiveRecord::Migration
  def change
    add_column :sites, :automap, :boolean
  end
end

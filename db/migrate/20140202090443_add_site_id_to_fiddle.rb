class AddSiteIdToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :site_id, :integer
  end
end

class AddPreviewToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :preview_url, :string
  end
end

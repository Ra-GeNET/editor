class AddHiddenToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :noindex, :boolean
  end
end

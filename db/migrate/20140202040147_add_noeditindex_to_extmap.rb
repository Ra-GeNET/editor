class AddNoeditindexToExtmap < ActiveRecord::Migration
  def change
    add_column :extmaps, :noedit, :boolean
    add_column :extmaps, :noindex, :boolean
  end
end

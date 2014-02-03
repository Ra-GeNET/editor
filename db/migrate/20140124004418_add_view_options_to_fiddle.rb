class AddViewOptionsToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :lang, :string
    add_column :fiddles, :skin, :string
    add_column :fiddles, :fontsize, :string
    add_column :fiddles, :lineheight, :string
  end
end

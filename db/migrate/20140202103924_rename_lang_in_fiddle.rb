class RenameLangInFiddle < ActiveRecord::Migration
  def change
    rename_column :fiddles, :lang, :langcode
  end
end

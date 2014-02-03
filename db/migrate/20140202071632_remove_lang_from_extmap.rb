class RemoveLangFromExtmap < ActiveRecord::Migration
  def change
    remove_column :extmaps, :lang, :string
  end
end

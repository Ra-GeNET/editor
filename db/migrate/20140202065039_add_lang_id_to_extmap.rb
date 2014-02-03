class AddLangIdToExtmap < ActiveRecord::Migration
  def change
    add_column :extmaps, :lang_id, :integer
  end
end

class AddLangIdToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :lang_id, :integer
  end
end

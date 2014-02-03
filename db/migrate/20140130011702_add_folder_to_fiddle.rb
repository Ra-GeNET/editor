class AddFolderToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :folder, :string
  end
end

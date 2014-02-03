class AddFilePathToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :file_path, :string
  end
end

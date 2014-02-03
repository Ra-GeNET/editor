class AddCategoriesToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :category, :string
  end
end

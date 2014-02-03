class AddCategoriesToExtmap < ActiveRecord::Migration
  def change
    add_column :extmaps, :category, :string
  end
end

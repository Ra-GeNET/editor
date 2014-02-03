class AddCategoriesToLangs < ActiveRecord::Migration
  def change
    add_column :langs, :category, :string
  end
end

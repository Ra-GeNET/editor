class AddModifiedToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :modified, :boolean
  end
end

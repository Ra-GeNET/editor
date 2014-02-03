class AddDeletedAtToFiddle < ActiveRecord::Migration
  def change
    add_column :fiddles, :deleted_at, :timestamp
  end
end

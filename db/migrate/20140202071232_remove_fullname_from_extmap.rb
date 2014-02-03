class RemoveFullnameFromExtmap < ActiveRecord::Migration
  def change
    remove_column :extmaps, :fullname, :string
  end
end

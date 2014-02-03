class AddFullnameToExtmap < ActiveRecord::Migration
  def change
    add_column :extmaps, :fullname, :string
  end
end

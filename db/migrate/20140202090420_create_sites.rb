class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :file_path
      t.string :title

      t.timestamps
    end
  end
end

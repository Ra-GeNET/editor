class CreateSkins < ActiveRecord::Migration
  def change
    create_table :skins do |t|
      t.string :title
      t.string :code

      t.timestamps
    end
  end
end

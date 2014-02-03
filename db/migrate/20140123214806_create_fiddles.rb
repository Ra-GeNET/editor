class CreateFiddles < ActiveRecord::Migration
  def change
    create_table :fiddles do |t|
      t.string :title
      t.text :code

      t.timestamps
    end
  end
end
